# 2FA
get 'enable_otp_show_qr', to: 'users#enable_otp_show_qr', as: 'enable_otp_show_qr'
post 'enable_otp_verify', to: 'users#enable_otp_verify', as: 'enable_otp_verify'

get 'users/otp', to: 'users#show_otp', as: 'user_otp'
post 'users/otp', to: 'users#verify_otp', as: 'verify_user_otp'
post 'verify_otp', to: 'users/sessions#verify_otp'

get '/users/:user_id/friend', to: 'users#friend_request'
get '/profile', to: 'users#show'
resources :friends, :user_board