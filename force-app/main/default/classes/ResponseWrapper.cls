public class ResponseWrapper {

    public string State {get; set;}
    public string Message {get; set;}
    public object Data {get; set;}
    private static ResponseWrapper instance = null;
    
    private ResponseWrapper(string type, string message, object data) 
    {
        this.State = type;
        this.Message = message;
        this.data = data;
        
    }        
    
    public static ResponseWrapper getInstance(string state, string message, object data ) 
    {
        if (instance == null)
        {
            instance = new ResponseWrapper(state, message, data);
        }
        else
        {
            instance.State = state;
            instance.Message = message;
            instance.Data = data;
        }
        return instance;
    } 

        
}