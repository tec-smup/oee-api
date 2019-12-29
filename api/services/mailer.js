'use strict';
const nodemailer = require('nodemailer');

module.exports = function(api) {
    //let _user = api.models.user;

    this.send = async (to, subject, html) => {  
        // create reusable transporter object using the default SMTP transport
        let transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: process.env.NODEMAILER_EMAIL,
                pass: process.env.NODEMAILER_PASS 
            }
        });   
            
        // send mail with defined transport object
        await transporter.sendMail({
            from: process.env.NODEMAILER_EMAIL,
            to: to,
            subject: subject,
            html: html
        }, 
        (err, info) => {
            if(err) console.log('Email error:', err)
        });         
    }; 
    
    return this;
};