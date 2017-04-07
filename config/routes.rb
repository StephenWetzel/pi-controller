Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/api' do
    scope '/v1' do
      resources :devices do
        member do
          get 'event/:event_code', action: :event
        end
      end
      resources :event_logs do
        collection do
          get ':event_count', action: :get_count
        end
      end
    end
  end

  mount ActionCable.server => '/cable'
end
