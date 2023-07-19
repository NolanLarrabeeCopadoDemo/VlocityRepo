/*
* @author Salesforce.com
* @date 2020-12-11
*
* @description: Request for Enrollment API
*/
public with sharing class B2BManufacturingEnrollMemberRequest {    

    public Member member;

    public class Account {
		public String name;
		public Address address;
	}    
    public class Contact {
		public String phone;
		public String lastName;
		public String firstName;
		public String email;
		public String birthDate;
		public Address address;
    }
    public class Address {
        public String street;
        public String state;
        public String postalCode;
        public String country;
        public String city;
    }

    public class Member {
        public Account account;
		public Contact contact;
    }
}