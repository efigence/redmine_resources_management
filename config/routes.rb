resources :devices do
  post :create_loan

end
get 	'devices/:device_id/:id/return', to: 'devices#return', as: 'return_loan'