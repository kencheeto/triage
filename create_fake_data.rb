require 'rubygems'
gem 'byebug'; require 'byebug'
gem 'faraday'; require 'faraday'
require 'json'
base = "https://z3nios.zendesk.com/api/v2/tickets"

admin_username = "ckintner@zendesk.com"
admin_password = ""

@users =  [809222997, 809224527, 814924738, 814925128, 814926158]
new_ticket_comments = ["Help! My printer is on fire!", "I can't login!", "I see the bad moon arising. I see trouble on the way. I see earthquakes and lightnin'. I see bad times today."]
subjects = ["Urgent Issue", "Please help me right away", "I need help now", "Can you fix this?"]
followups = ["This is fixed!", "This will be fixed in our next release", "Hey Bob: Can you look into this?", "Are you still having this issue?"]

@conn = Faraday.new
@conn.basic_auth(admin_username, admin_password)


# {"ticket": {"requester": {"name": "The Customer", "email": "thecustomer@domain.com"}, "submitter_id": 410989, "subject": "My printer is on fire!", "comment": { "body": "The smoke is very colorful." }}}' \
# -H "Content-Type: application/json" -v -u {email_address}:{password} -X POST


def self.create_ticket(requester, subject, text)
  json = {
    "ticket" => {
      "requester_id" => requester,
      "subject" => subject,
      "comment" => {
        "body" => text
      }
    }
  }

  response = JSON.parse(@conn.post("https://z3nios.zendesk.com/api/v2/tickets.json", json).body)
  response["ticket"]["id"]
end


def self.add_comment(ticket_id, user, text)
  json = {
    "ticket" => {
      "comment" => {
        "body" => text,
        "author_id" => user
      }
    }

  }
  @conn.put("https://z3nios.zendesk.com/api/v2/tickets/#{ticket_id}.json", json)
end


500.times do
  id = create_ticket(@users.sample, subjects.sample, new_ticket_comments.sample)
  (1..4).to_a.sample.times do
    add_comment(id, @users.sample, followups.sample)
  end
end

