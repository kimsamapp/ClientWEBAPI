using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;

namespace WebAPIv1._1.Utils
{
    public class SendEmail
    {
        private const string emailSubjectDefault = "[Email Notification]";
        //private const string smtpHost = "mailhost.apac.bg.corpintra.net";
        //private const string smtpHost = "wksmtphub.wk.dcx.com";
        //private const string smtpHost = "mailhost.apac.bg.corpintra.net";
        private const string smptPort = "25";
        public async Task<bool> SendEmailAsync(
                                                  string email,
                                                  string mailfrom,
                                                  string mailfrompassword,
                                                  string msg,
                                                  string subject,
                                                  string smtpHost
                                                )
        {
            bool flag = false;
            try
            {
                string str = msg;
                MailMessage mailMessage = new MailMessage();
                ((Collection<MailAddress>)mailMessage.To).Add(new MailAddress(email));
                mailMessage.From = new MailAddress(mailfrom);
                mailMessage.Subject = !string.IsNullOrEmpty(subject) ? subject : emailSubjectDefault;
                mailMessage.Body = str;
                mailMessage.IsBodyHtml = true;
                using (SmtpClient smtp = new SmtpClient())
                {
                    smtp.Credentials = (ICredentialsByHost)new NetworkCredential()
                    {
                        UserName = mailfrom,
                        Password = mailfrompassword
                    };
                    smtp.Host = smtpHost;
                    smtp.Port = Convert.ToInt32(smptPort);
                    smtp.EnableSsl = true;
                    await smtp.SendMailAsync(mailMessage);
                    flag = true;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return flag;
        }

        public async Task<bool> SendEmailAsyncBcc(
                                                      string email,
                                                      string emailBcc,
                                                      string mailfrom,
                                                      string mailfrompassword,
                                                      string msg,
                                                      string subject,
                                                      string smtpHost
                                                    )
        {
            bool flag = false;
            try
            {
                string str = msg;
                MailMessage mailMessage = new MailMessage();
                ((Collection<MailAddress>)mailMessage.To).Add(new MailAddress(email));
                mailMessage.From = new MailAddress(mailfrom);
                ((Collection<MailAddress>)mailMessage.Bcc).Add(new MailAddress(emailBcc));
                mailMessage.Subject = !string.IsNullOrEmpty(subject) ? subject : emailSubjectDefault;
                mailMessage.Body = str;
                mailMessage.IsBodyHtml = true;
                using (SmtpClient smtp = new SmtpClient())
                {
                    smtp.Credentials = (ICredentialsByHost)new NetworkCredential()
                    {
                        UserName = mailfrom,
                        Password = mailfrompassword
                    };
                    smtp.Host = smtpHost;
                    smtp.Port = Convert.ToInt32(smptPort);
                    smtp.EnableSsl = true;
                    await smtp.SendMailAsync(mailMessage);
                    flag = true;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return flag;
        }
    }
}
