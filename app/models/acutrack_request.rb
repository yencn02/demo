class AcutrackRequest

  HEADER = {
    "Authentication" => {
      "TokenKey"       => TOKEN_KEY,
      "DealerID"       => DEALER_ID,
      "DealerPassword" => DEALER_PASSWORD
    }
  }

  BODY = {
    "Request" => {
      "Headers" => HEADER,
      "RequestMethodName" => "CreateProductAndOrder",
      "RequestDocument" => {}
    }
  }

  MESSAGE_CODE_PATH = "/OnlineDuplication/Response/ResponseDocument/Orders/Order/Messages/Message/MessageCode"
  MESSAGE_PATH = "/OnlineDuplication/Response/ResponseDocument/Orders/Order/Messages/Message/Message"

  TRACKING_PATH = {
    :approval_code => "/ShippingConfirmation/Orders/Order/ApprovalCode",
    :dealer_id => "/ShippingConfirmation/Orders/Order/DealerID",
    :tracking_number => "/ShippingConfirmation/Orders/Order/TrackingNumber"
  }

  SHIPPING_RESPONSE = {
    :status => {"true" => "Success", "false" => "Error"},
    :message => {"true" => "The tracking number has already been updated.", "false" => "Can't update tracking number. Please double check the approval code."}
  }

  XMLNS = "urn:acutrack:shippingConfirmation"

  class << self

    def get_tracking_number(xmlstr)
      doc = REXML::Document.new(xmlstr)
      begin
        tracking_info = {
          :approval_code => doc.get_elements(TRACKING_PATH[:approval_code]).first.text,
          :dealer_id => doc.get_elements(TRACKING_PATH[:dealer_id]).first.text,
          :tracking_number => doc.get_elements(TRACKING_PATH[:tracking_number]).first.text
        }
      rescue
        tracking_info = {}
      end
      return tracking_info
    end

    def build_shipping_response_xml(tracking_info, status)
      hash = {
        "ShippingConfirmationResponse" => {
          "Orders" => {
            "Order" => {
              "ApprovalCode" => tracking_info[:approval_code],
              "Status" => SHIPPING_RESPONSE[:status][status.to_s],
              "Message" => SHIPPING_RESPONSE[:message][status.to_s]
            }
          }
        }
      }
      hash.to_soap_xml.gsub("<ShippingConfirmationResponse>", "<ShippingConfirmationResponse xmlns=\"#{XMLNS}\">")
    end

    def build_order_xml(order_hash)
      request = {"Orders" => [{"Order" => order_hash}]}
      body = BODY.clone
      body["Request"]["RequestDocument"] = request
      body.to_soap_xml.gsub("<RequestDocument>", "<RequestDocument LiveTransaction=\"#{LIVE_TRANSACTION}\">")
    end
    
    def post_data(xml)
      begin
        params = {"xmlStrPO" => xml}
        url = URI.parse(ORDER_CONFIRM_URL)
        req = Net::HTTP::Post.new(url.path)
        req.form_data = params
        con = Net::HTTP.new(url.host, url.port)
        con.use_ssl = true
        res = con.request(req)
        res.body
      rescue
        return nil
      end
    end

    def get_response_messages(response)
      begin
        doc = REXML::Document.new(response)
        message = {
          :code => doc.get_elements(MESSAGE_CODE_PATH).first.text,
          :message => doc.get_elements(MESSAGE_PATH).first.text
        }
        if order_number = message[:message].match(/\(.*.\)/)
          message[:order_number] = order_number.to_s.gsub(/\W/, "")
        end
      rescue Exception => ex
        message = {}
      end
      return message
    end

  end
  
end
