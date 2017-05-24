require './modules/score_module'
include ScoreModule

class Gene
  attr_accessor :score
  attr_accessor :code

  def initialize(mutation_rate)
    # a,b,c,d,e,fの変数で取りうる値は0(2進数で00000)〜31(2進数で11111)
    @mutation_rate = mutation_rate

    # 最大で5*6 = 30桁
    @code = Array.new(30){[0,1].sample}.join

    @score = scoring(decode)
  end

  def decode
    code_ary = @code.scan(/.{1,5}/).map { |code| code.to_i(2) }
    { a: code_ary[0],
      b: code_ary[1],
      c: code_ary[2],
      d: code_ary[3],
      e: code_ary[4],
      f: code_ary[5]}
  end

  def mutation!
    return if rand(100) > @mutation_rate

    # @mutation_rate%の確率で突然変異を発生させる
    # ランダムで3つの遺伝子情報を反転させる
    3.times do
      mutation_index = rand(@code.size)
      if @code[mutation_index] == "1"
        @code[mutation_index] = "0"
      else
        @code[mutation_index] = "1"
      end
    end
  end

  def re_scoring!
    @score = scoring(decode)
  end


end