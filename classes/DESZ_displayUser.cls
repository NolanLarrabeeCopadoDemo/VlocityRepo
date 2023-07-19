public class DESZ_displayUser {
    @Auraenabled
    public static List<User> getUsers()
    {
        return ([Select Id, Name from User where Name ='Tim Service' 
                 or Name ='James Technician' 
                 or Name='Ted Training' 
                 or Name='Steven Service']);
    }
    
}