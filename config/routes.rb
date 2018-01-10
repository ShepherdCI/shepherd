Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      omniauth_callbacks: "omniauth_callbacks"
    },
    path: '',
    skip: %w[sessions registrations]

  scope path: '/api' do
    resources :docs, only: [:index], path: '/swagger'

    scope path: '/v1' do
      resources :credentials
    end
  end

  get '*path' => 'index#index'
  root to: 'index#index'
end
