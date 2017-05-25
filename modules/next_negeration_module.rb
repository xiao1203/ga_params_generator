module NextGenerationModule
  # ルーレット選択で親世代から(gene_count/2)個を抽出し、（gene_count - 親世代上位5%のガチエリート数）個の子供を作る
  # 例：親世代が100なら子供の数は95
  # そこに親世代のガチエリートを加えたものを次世代とする
  def create_next_generation(genes_ary)
    parent_genes_ary = roulette(genes_ary)
    elites_count = (genes_ary.size * 0.05).to_i
    if elites_count.zero?
      elites_count = 1
    end

    child_genes_ary = []
    (genes_ary.size/2).times do |index|
      children = breed(parent_genes_ary[index - 1], parent_genes_ary[index])
      children.each do |child|
        child_genes_ary.push(child)
      end
    end

    # エリート追加
    # 下位グループからランダムでelites_count個リストラしてエリートを追加
    elites_count.times do
      child_genes_ary.delete_at(rand(child_genes_ary.size))
    end

    child_genes_ary += genes_ary[0...elites_count]

    child_genes_ary.sort! do |a, b|
      b.score <=> a.score
    end
    child_genes_ary
  end

  # sorted_genes_aryからsorted_genes_ary.size/2個抽出する
  # 処理方法はソート済みgenes_aryから4グループ（エリート、そこそこできる、及第点ギリギリ、落ちこぼれ）の4グループにわけ
  # そのグループindexをエリートびいきの「くじ」にして抽出する
  # ただし、上位5%のガチエリート勢は必ず入れる
  def roulette(genes_ary)
    # 5%のエリート（上位から降順に選定）は交叉の機会を増やす為、重複選出させる
    elites_count = (genes_ary.size * 0.05).to_i
    #
    grouping_genes = genes_ary.each_slice((genes_ary.size/4).to_i).to_a
    elites_genes = genes_ary[0...elites_count]

    result = []
    (genes_ary.size/2 - elites_count).times do
      rand_group_index = [0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,3].sample
      result.push(grouping_genes[rand_group_index].sample)
    end

    result += elites_genes
    result.shuffle
  end

  # 二点交叉で2つの子供を作る。子供は二人作りましょう！
  # 今回の遺伝子型は5個ずつの意味のある数字なので
  # index 15~25の位置の遺伝子を交叉させる
  def breed(father, mother)
    result = []
    father_cross_code = father.code[15...25]
    mother_cross_code = mother.code[15...25]


    child_code_1 = father.code[0...15] + mother_cross_code + father.code[25...30]
    child_code_2 = mother.code[0...15] + father_cross_code + mother.code[25...30]

    child_1 = father.clone
    child_1.code = child_code_1
    child_1.mutation!
    child_1.re_scoring!

    child_2 = mother.clone
    child_2.code = child_code_2
    child_2.mutation!
    child_2.re_scoring!

    [child_1, child_2]
  end
end