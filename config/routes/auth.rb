# Devise route configurations
devise_for :users, path: 'auth', path_names: {
  sign_in: 'login',
  sign_out: 'logout',
  registration: 'signup'
},
controllers: {
  sessions: 'users/sessions',
  registrations: 'users/registrations'
}