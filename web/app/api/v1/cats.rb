module V1
  class Cats < Grape::API
    resource :cats do

      desc 'Return all cats.'
      params do
        optional :page, type: Integer, desc: 'Page Num'
      end
      get do
        cats = InstagramCat.all.page(params[:page])
        cats.each do |cat|
          cat[:text].force_encoding('UTF-8')
          cat[:tags].force_encoding('UTF-8')
        end
        cats
      end

    end
  end
end
