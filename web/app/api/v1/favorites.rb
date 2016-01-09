module V1
  class Favorites < Grape::API

    helpers do
      def current_user
        @current_user
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end
    end

    resource :favorites do

      desc 'Return all cats.'
      params do
        requires :cat_id, type: Integer, desc: 'Cat ID'
      end
      get do
        authenticate!
        Favorite.create(user_id: current_user.id, cat_id: params[:cat_id])
        status 201
      end

    end
  end
end
