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
      resources :states
      resources :workflows
      resources :controllers do
        collection do
          get 'connections', action: :connections
          get 'connections/test', action: :connections_test
          get 'connections/details', action: :connections_details
        end
      end
      resources :events
    end
  end

  mount ActionCable.server => '/cable'
end
