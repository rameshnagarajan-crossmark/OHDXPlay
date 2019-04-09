global class ActionResponse
{
    public Id RecordId {get; set;}
    public Boolean IsSuccessful {get; set;}
    public string ResponseMessage {get; set;}
    public Boolean IsBatched {get;set;}
    
    global ActionResponse(Id pRecordId, Boolean pIsSuccessful, String pResponseMessage) 
    {
        RecordId = pRecordId;
        IsSuccessful = pIsSuccessful;
        ResponseMessage = pResponseMessage;
    }    

    global static ActionResponse newInstance(Id pRecordId, Boolean pIsSuccessful, String pResponseMessage) {
        return new ActionResponse (pRecordId, pIsSuccessful, pResponseMessage);
    }
    
}