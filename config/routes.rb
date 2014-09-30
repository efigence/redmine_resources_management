get 'devices/get_phone', to: 'devices#get_phone', as: 'device_get_phone'
resources :devices do
	post :create_loan

end
get 'devices/:device_id/:id/return', to: 'devices#return', as: 'return_loan'
