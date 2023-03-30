# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    accountable = if params[:user][:role] == "customer"
                    Customer.create!(accountable_params)
                  elsif params[:user][:role] == "seller"
                    Seller.create!(accountable_params)
                  end

    cart=Cart.new
    cart.customer_id=accountable.id
    cart.save

    build_resource(sign_up_params)
    resource.accountable_id = accountable.id
    resource.accountable_type = params[:user][:role].camelcase
    resource.save

    @address=Address.new(address_params)
      @address.addressable_id=accountable.id
      @address.addressable_type=params[:user][:role].camelcase
    @address.save



    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end

  def accountable_params
    params.require(:details).permit(:name, :age, :mbl_no)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    # super(resource)
    if resource.accountable_type=="Seller"
      seller_path(resource.accountable_id)
    elsif resource.accountable_type=="Customer"
      customer_path(resource.accountable_id)
    end
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  # private
  # def user_params
  #   params.require(:user).permit(:email,:role,:password)
  # end

  def address_params
    params.require(:address).permit(:door_no,:street,:district,:state,:pincode)
  end

end
