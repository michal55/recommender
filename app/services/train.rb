module Train
  extend self
  def basic
    deal_ids = Activity.where(user_id: '523801').pluck(:deal_id)
    deals = Detail.where(deal_id: deal_ids).pluck(:title_deal)
    merged = ""
    deals.each do |title|
      merged += "#{title} "
    end
    top_keywords = []
    keywords = merged.keywords(Highscore::Blacklist.load(['alebo']))
    keywords.rank.each do |k|
      top_keywords.push(k.text) if k.weight >= 4
    end

    top_keywords.each{|t| puts t}




  end

end

