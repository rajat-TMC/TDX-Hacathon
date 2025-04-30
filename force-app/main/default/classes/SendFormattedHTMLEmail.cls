public with sharing class SendFormattedHTMLEmail {

    public class EmailInput {
        @InvocableVariable(label='Contact Email' required=true)
        public String emailAddress;

        @InvocableVariable(label='Email Subject' required=true)
        public String emailSubject;

        @InvocableVariable(label='Email Body (Raw Text)' required=true)
        public String emailBody;
    }

    public class EmailOutput {
        @InvocableVariable(label='Status Message')
        public String status;
    }

    @InvocableMethod(label='Send HTML Formatted Email')
    public static List<EmailOutput> sendEmail(List<EmailInput> inputList) {
        List<EmailOutput> results = new List<EmailOutput>();
		String orgWideEmailAddressId = [Select id, DisplayName from OrgWideEmailAddress Where DisplayName = 'Salesforce PulseConnect'  LIMIT 1].id;
        for (EmailInput input : inputList) {
            EmailOutput result = new EmailOutput();

            try {
                // Convert \n and \r to <br/> for HTML rendering
                String htmlBody = input.emailBody != null
                    ? input.emailBody
                        .replace('\\n', '<br/>')  // newlines
                        .replace('\\r', '')       // remove carriage returns
                    : '';

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { input.emailAddress });
                mail.setSubject(input.emailSubject);
                mail.setHtmlBody(htmlBody);
                mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
				System.debug(mail);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

                result.status = 'Email sent successfully to ' + input.emailAddress;
            } catch (Exception e) {
                result.status = 'Error sending email: ' + e.getMessage();
            }

            results.add(result);
        }

        return results;
    }
}