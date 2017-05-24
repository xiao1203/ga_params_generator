require './models/gene'
require './modules/next_negeration_module'
include NextGenerationModule
require "thor"
require "pry"

class Generator
  def initialize(gene_count, mutation_rate)
    @gene_count = gene_count # 遺伝子数（その世代の数）
    @mutation_rate = mutation_rate # 突然変異率（0〜100）
    raise Exception.new("突然変異率は0〜100の間") if @mutation_rate < 0 || @mutation_rate > 100

    @generation_count = 1
    @genes_ary = []
  end

  def execute
    # @gene_countの数だけ遺伝子を作る
    # 第一世代
    @gene_count.times do
      @genes_ary.push(Gene.new(@mutation_rate))
    end

    # 評価値順にソート
    @genes_ary.sort! do |a, b|
       b.score <=> a.score
    end

    loop do
      ga_log

      @genes_ary = create_next_generation(@genes_ary)
      @generation_count += 1

      if @generation_count == 100
        ga_log

        puts "========================="
        puts "【最終結果】"
        puts "試行世代数:#{@generation_count}世代"
        puts "最適パラメータ：第一位：#{@genes_ary.first.decode}"
        puts "========================="
        break
      end
    end

  end

  private

  def ga_log
    puts "第#{@generation_count}世代-----------------------------------------------------"
    @genes_ary.each do |gene|
      puts "遺伝子コード： #{gene.code} 評価値： #{gene.score} "
    end
    puts "--------------------------------------------------------------"
  end
end


Generator.new(100, 5).execute
