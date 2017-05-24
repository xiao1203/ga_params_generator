module ScoreModule
  def scoring(hs)
    # とりあえず適当な数式
    ((2 * hs[:a]) + (3 * hs[:b]) - (4 * hs[:c]) + (5 * hs[:e])/(60 * hs[:f] + 100)) * hs[:e] + (hs[:c] * hs[:f])
  end
end