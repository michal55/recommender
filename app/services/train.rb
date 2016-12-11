require 'net/http'
module Train
  extend self
  def basic user_id
    deal_ids = Activity.where(user_id: user_id).pluck(:deal_id)
    deals = Detail.where(deal_id: deal_ids).pluck(:title_deal)
    merged = ""
    deals.each do |title|
      merged += bash(process(title))
    end
    top_keywords = []
    keywords = merged.keywords(Highscore::Blacklist.load(['alebo', 'a']))
    keywords.rank[0...10].each do |k|
      top_keywords.push(k.text)
    end

    top_keywords
  end

  def deal_keywords detail_id
    title = Detail.find(detail_id).title_deal
    title.split(' ').each do |word|
      puts word
    end

  end

  def bash(sentence)
    `echo "#{sentence}" | stemmsk light`
  end

  def process(sentence)
    arr = ["alebo", "ale"]
    I18n.transliterate(sentence).downcase.delete('^a-z ').split.delete_if{|x| arr.include?(x)}.join(' ')
  end
  
end

# 523801