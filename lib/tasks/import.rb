require 'csv'
csv_text = File.read(Rails.root.join('lib','seeds','train_activity_v2.csv'))
csv = CSV.prase(csv_text, :headers => true, :encoding => 'ISO-8859-1')
puts csv_text
