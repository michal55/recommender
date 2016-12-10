class Activity < ActiveRecord::Base
	belongs_to :deal_item
	belongs_to :detail
	require 'matrix'

	# def tf
	# 	document1 = TfIdfSimilarity::Document.new("200 g Entrecôte hovädzí steak (Rib eye steak) s pečenými zemiakmi a pfefer omáčkou")
	# 	document2 = TfIdfSimilarity::Document.new("200 g Steak z hovädzej sviečkovice s pečenými zemiakmi a pfefer omáčkou")
	# 	document3 = TfIdfSimilarity::Document.new("200 g Steak z hovädzej sviečkovice s pečenými zemiakmi a pfefer omáčkou")
	# 	corpus = [document1, document2, document3]
	# 	model = TfIdfSimilarity::TfIdfModel.new(corpus)
	# 	matrix = model.similarity_matrix
	# 	puts matrix[model.document_index(document3), model.document_index(document2)]
  #
	# end



	def similarity
		documents = []
		docs = []

		Detail.first(500).each do |detail|
			documents.push(TfIdfSimilarity::Document.new(detail.title_deal))
			docs.push detail.title_deal
		end
		model = TfIdfSimilarity::TfIdfModel.new(documents)
		matrix = model.similarity_matrix
		# puts docs[25]
		# puts docs[26]
		puts docs[0]
		result = Hash.new
		(0..documents.size-1).each do |i|
			result[i] = matrix[model.document_index(documents[0]), model.document_index(documents[i])]
			# result[i]['id'] = i
			# result[i]['tfidf'] =
		end
		# result.sort_by('tfidf')
		# (0..10).each do |i|
		# 	puts result[i]
		# end
		result.sort_by {|k, v| v}
		result.each_pair{|k, v| puts "#{v}  #{docs[k]}"}[0..10]
		# puts result.first.value
	end
end
