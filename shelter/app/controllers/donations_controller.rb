class DonationsController < ApplicationController
	 def index
	 	@donations = current_user.donations
	end

	def new
		# @donation = Donation.new
	end

	def create
		  	# Amount in cents
  		@amount = 500

	  	customer = Stripe::Customer.create(
    		:email => 'example@stripe.com',
    		:card  => params[:stripeToken]
  		)

  		charge = Stripe::Charge.create(
    		:customer    => customer.id,
    		:amount      => @amount,
    		:description => 'Rails Stripe customer',
    		:currency    => 'usd'
  		)

  		current_amount = charge.amount
  		current_transaction = charge.id #make this the charge.receipt_number
  		new_donation = Donation.create(
  			:user_id => current_user.id,
  			:amount => current_amount,
  			:transaction_id => current_transaction 
  		)


		rescue Stripe::CardError => e
  		flash[:error] = e.message
  		redirect_to donations_path
  		
	
	
	end

	def show
		@donation = Donation.find(params[:id])
	end

	private
	def donation_params
		white_list = [
						:user_id, :campaign_id, 
						:amount, :transaction_id
						]
		params.require.(:donation).permit(*white_list)
	end

	def set_user_donation
		@donation = current_user.donations.find(params[:id])
	end

end
