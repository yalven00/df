require 'rubygems'
require 'savon'

class Ewayapi

  @sessionId = ''


  #####
  # Session method : login
  # Authenticates the user and returns a sessionId to use in subsequent method calls.
  # A fault is thrown if the authentication fails.
  # Function:
  # String login(String username, String password)

  def login
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Session"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :login) do
      soap.body = {"soap:username"=>"soapapi8554", "soap:password"=>"dfmS0@P11563"}
    end
    @sessionId = response.body[:login_response][:out] unless response.body[:login_response][:out].nil?
  end


  #####
  # Session method : logout
  # Description: Ends the current session. The passed sessionId will no longer be valid.
  #	Function:
  # void logout(String sessionId)

  def logout(sessionId)
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Session"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :logout) do
      soap.body = { "soap:sessionId" => @sessionId }
    end
  end


  #####
  # Campaign method : createCampaign
  # Description: Creates a new campaign using the specified parameters and returns its id.
  # The parameters listId, fromName, fromEmail, and supportEmail default to the values from
  # the campaign type's default campaign.
  # Function:
  # 	int createCampaign(
  #  	String sessionId,
  #  	String name,         // name of the campaign, required
  #  	int campaignTypeId,  // id of campaign type to use, required
  #  	int listId,          // id of list to mail to (if 0 use listId from default campaign)
  #  	String subject,      // email subject, required
  #  	String textMsg,      // text for email body, required
  # 		String htmlMsg,      // HTML for email body, required
  #  	String fromName,     // from name to display
  #  	String fromEmail,    // from email to use (only enter the part before the @)
  #  	String supportEmail, // email to receive unknown responses
  #  	Date scheduleDate    // date and time to send campaign, if null is passed the campaign won't be scheduled

  def createCampaign(sessionId, name, campaignTypeId, listId, subject, text, html, fromName, fromEmail, supportEmail, scheduleDate)
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Campaign"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :createCampaign) do
      soap.body = {
          "soap:sessionId"      => sessionId,
          "soap:name"           => name,
          "soap:campaignTypeId" => campaignTypeId,
          "soap:listId"         => listId,
          "soap:subject"        => subject,
          "soap:text"           => text,
          "soap:html"           => html,
          "soap:fromName"       => fromName,
          "soap:fromEmail"      => fromEmail,
          "soap:supportEmail"   => supportEmail,
          "soap:scheduleDate"   => scheduleDate
      }
    end
  end


  #####
  # Campaign method : setCampaignCloseDate
  # Description:  Sets a custom close date for a campaign. By default, the close date of a campaign is set to 24 hours
  # after the scheduled send date. This default can also be customized per campaign type.
  # The method setCampaignCloseDate should be used when it is necessary to override the default campaign close date.
  # The following restrictions apply:
  # The campaign must be scheduled in order to set the close date.
  # The close date must be at least 4 hours and no more than 48 hours after the scheduled send date.
  # Function:
  #   void setCampaignCloseDate(
  #  	String sessionId,
  #  	int campaignId,    // id of campaign, required
  #  	Date date)         // close date of campaign, required

  def setCampaignCloseDate(sessionId, campaignId, closeDate)
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Campaign"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :setCampaignCloseDate) do
      soap.body = {
          "soap:sessionId"      => sessionId,
          "soap:campaignId"     => campaignId,
          "soap:date"           => closeDate
      }
    end
  end


  #####
  # Campaign method: sendCampaignPreview
  # Description: Sends a preview of a campaign to a list of email addresses. All addresses must be in the PREVIEW database
  # Function:
  # void sendCampaignPreview(
  #  String sessionId,
  #  int campaignId,    // id of campaign, required
  #  String addresses,  // comma separated list of email addresses to send to, required
  #  String format)     // content type of email ('text', 'html' or 'txml' (i.e., text and html)), required

  def sendCampaignPreview(sessionId, campaignId, addresses, format='txml')
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Campaign"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :sendCampaignPreview) do
      soap.body = {
          "soap:sessionId"      => sessionId,
          "soap:campaignId"     => campaignId,
          "soap:addresses"      => addresses,
          "soap:format"         => format
      }
    end
  end


  #####
  # Campaign method: getCampaignStats
  # Description: Returns statistics for a campaign.
  # Function:
  # String getCampaignStats(
  #  String sessionId,
  #  int campaignId)      // id of campaign, required

  def getCampaignStats(sessionId, campaignId)
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Campaign"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :getCampaignStats) do
      soap.body = {
          "soap:sessionId"      => sessionId,
          "soap:campaignId"     => campaignId
      }
    end
  end


  #####
  # Campaign method: getManagedCampaignTypes
  # Description: Get the list of campaign types that can be managed by subscribers.
  # Function:
  # String getManagedCampaignTypes(String sessionId)

  def getManagedCampaignTypes(sessionId)
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Campaign"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :getManagedCampaignTypes) do
      soap.body = {
          "soap:sessionId"      => sessionId
      }
    end
  end


  #####
  # Campaign method: getCampaignInfo
  # Description: Get delivery and sales information for a particular campaign. This method will return detailed
  # subscriber level information for a campaign, whereas the getCampaignStats() method returns statistical information.
  # Action is a pipe delimited value indicating which user action(s) information to retrieve.
  # Valid values are: SENT, DELIVERED, OPENED, UNSUBSCRIBED, BOUNCED, CLICKED, REVENUE, LINKSCLICKED and ALL.
  # If the action contains REVENUE, LINKSCLICKED, UNSUBSCRIBED or ALL the request will return a "pending" response with
  # a "pendingRequestId". After 5 minutes, you may use the status method to retrieve the campaign results or a status update.
  # Function:
  # String getCampaignInfo(
  #  String sessionId,
  #  int campaignId,    // id of campaign, required
  #  String email,      // information for campaign sent to a particular email address, optional
  #  String action)     // See usage information below, required

  def getCampaignInfo(sessionId, campaignId, email='', action)
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Campaign"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :sendCampaignPreview) do
      soap.body = {
          "soap:sessionId"      => sessionId,
          "soap:campaignId"     => campaignId,
          "soap:email"          => email,
          "soap:action"         => action
      }
    end
  end


  #####
  # Campaign method: getCampaignInfoByDate
  # Description: Retrieve the campaigns sent to a particular email address for a given date range.
  # Action is a pipe delimited value indicating which user action(s) information to retrieve.
  # Valid values are: SENT, DELIVERED, OPENED, UNSUBSCRIBED, BOUNCED, CLICKED, REVENUE, LINKSCLICKED and ALL.
  # If the action contains REVENUE, LINKSCLICKED, UNSUBSCRIBED or ALL the request will return a "pending" response with
  # a "pendingRequestId". After 5 minutes, you may use the status method to retrieve the campaign results or a status update.
  # Function:
  #  String getCampaignInfoByDate(
  #  String sessionId,
  #  String email,    // email address to search details for, required
  #  Date startDate,  // Start date of the date range; assumes beginning of day 00:00:00, required
  #  Date endDate,    // End date of the date range; assumes end of day 23:59:59, required
  #  String action)   // See usage information below, required

  def getCampaignInfoByDate(sessionId, email, startDate, endDate, action)
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Campaign"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :getCampaignInfoByDate) do
      soap.body = {
          "soap:sessionId"      => sessionId,
          "soap:email"          => email,
          "soap:startDate"      => startDate,
          "soap:endDate"        => endDate,
          "soap:action"         => action
      }
    end
  end


  #####
  # Subscriber method: addSubscriber
  # Description: Adds a subscriber (or updates an existing one) and performs actions associated with a predefined handler.
  # Function:
  # String addSubscriber(
  #  String sessionId,
  #  String email,            // email address of subscriber; required
  #  String subscriberData,   // subscriber data; may be null; see format below
  #  int handlerId,           // id of handler to process subscriber; required  (list id)
  #  String handlerData)      // handler data; may be null; see format below

  def addSubscriber(sessionId, email, subscriberData, handlerId, handlerData='')
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Campaign"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :addSubscriber) do
      soap.body = {
          "soap:sessionId"      => sessionId,
          "soap:email"          => email,
          "soap:subscriberData" => subscriberData,
          "soap:handlerId"      => handlerId,
          "soap:handlerData"    => handlerData
      }
    end
  end


  #####
  # Subscriber method: getSubscriber
  # Description: Retrieves profile data for a subscriber.
  # Function:
  #	String getSubscriber(
	# String sessionId,
	# String email)      // email address of subscriber, required

  def getSubscriber(sessionId, email)
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Campaign"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :getSubscriber) do
      soap.body = {
          "soap:sessionId"      => sessionId,
          "soap:email"          => email
      }
    end
  end


  #####
  # Subscriber method: getSubscriptionStatus
  # Description: Retrieves the subscription status of each managed campaign type for a subscriber.
  # Function:
  # String getSubscriptionStatus(
  #  String sessionId,
  #   String email)      // email address of subscriber, required

  def getSubscriptionStatus(sessionId, email)
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Campaign"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :getSubscriptionStatus) do
      soap.body = {
          "soap:sessionId"      => sessionId,
          "soap:email"          => email
      }
    end
  end


  #####
  # Subscriber method: setSubscriptionStatus
  # Description: Sets the subscription status of each managed campaign type for a subscriber.
  # Function:
  # void setSubscriptionStatus(
  #  String sessionId,
  #  String email,              // subscriber's email
  #  String subscriptionData)   // XML string with subscription status to set (see below)

  def setSubscriptionStatus(sessionId, email, subscriptionData)
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Campaign"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :setSubscriptionStatus) do
      soap.body = {
          "soap:sessionId"        => sessionId,
          "soap:email"            => email,
          "soap:subscriptionData" => subscriptionData
      }
    end
  end


  #####
  # Subscriber method: blacklistSubscriber
  # Description: Blacklists a subscriber so they will no longer receive any messages.
  # Function:
  # 	void blacklistSubscriber(
  #  String sessionId,
  #  String email)       // email to blacklist, required

 def blacklistSubscriber(sessionId, email)
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Campaign"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :blacklistSubscriber) do
      soap.body = {
          "soap:sessionId"        => sessionId,
          "soap:email"            => email
      }
    end
 end


  #####
  # Subscriber method: getBlackListed
  # Description: Retrieve the subscribers who were BlackListed in a given date range
  # Function:
  # String getBlackListed(
  #  String sessionId,
  #  Date startDate,  // Start date of the date range; assumes beginning of day 00:00:00, required
  #  Date endDate,    // End date of the date range; assumes end of day 23:59:59, required

  def getBlackListed(sessionId, startDate, endDate)
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Campaign"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :getBlackListed) do
      soap.body = {
          "soap:sessionId"  => sessionId,
          "soap:startDate"  => startDate,
          "soap:endDate"    => endDate
      }
    end
  end

  #####
  # Subscriber method: changeEmail
  # Description: Changes a subscribers email address
  # Function:
  #  void changeEmail(
  #  String sessionId,
  #  String oldEmail,    // old email address, required
  #  String newEmail)    // new email address, required

  def changeEmail(sessionId, oldEmail, newEmail)
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Campaign"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :changeEmail) do
      soap.body = {
          "soap:sessionId"  => sessionId,
          "soap:oldEmail"   => oldEmail,
          "soap:newEmail"   => newEmail
      }
    end
  end


  #####
  # Subscriber method: status
  # Description: Request the status of a pending request. If the request, as identified by the pendingRequestId, has
  # completed this method will return the results corresponding to the initial request.
  # Otherwise a response of still pending will be returned as shown below.
  # Function:
  #  void changeEmail(
  #  String sessionId,
  #  String oldEmail,    // old email address, required
  #  String newEmail)    // new email address, required

  def changeEmail(sessionId, oldEmail, newEmail)
    client = Savon::Client.new do
      wsdl.endpoint = "https://soap.ixs1.net/1/Campaign"
      wsdl.namespace = "http://soap.service.eway"
    end
    response = client.request(:soap, :changeEmail) do
      soap.body = {
          "soap:sessionId"  => sessionId,
          "soap:oldEmail"   => oldEmail,
          "soap:newEmail"   => newEmail
      }
    end
  end
end