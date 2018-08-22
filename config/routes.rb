Rails.application.routes.draw do
  get 'new_action', to: 'foreman_gridscale/hosts#new_action'
end
