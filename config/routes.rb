Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/api' do
    scope '/v1' do
      resources :devices do
        member do
          get 'event'
        end
      end
    end
  end

  mount ActionCable.server => '/cable'
end
