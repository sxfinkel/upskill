class ContactsController < ApplicationController

  # GET request to /contact-us
  # Show new contract form
  def new
    @contact = Contact.new
  end

  # Post request to /contacts  
  def create
    # Mass asignment of form fields into Contact object
    @contact = Contact.new(contact_params)
    # Save the Contact object to the database
    if @contact.save
      # Store the form fields via paramaters, into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # Plug variables into Contact Mailer
      # Email method and send email
      ContactMailer.contact_email(name, email, body).deliver
      #Stor success message in flash hash and redirect to new action
      flash[:success] = "Message sent."
       redirect_to new_contact_path
    else
      # If Contact object doesn't save, store erros in flash hash and redirect to new action
      flash[:danger] = @contact.errors.full_messages.join(", ")
       redirect_to new_contact_path
    end
  end
  
  private
  # To collect data from form, we need to use strong paramaters and whitelist the fields
    def contact_params
       params.require(:contact).permit(:name, :email, :comments)
    end

end