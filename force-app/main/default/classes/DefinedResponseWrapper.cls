public class DefinedResponseWrapper {
        
        @AuraEnabled
        public Boolean Active {get; set;}
    
        @AuraEnabled    
        public string DefinedResponseId {get; set;}

        @AuraEnabled    
        public string ProjectServiceQuestionDefinedResponseId {get; set;}

        @AuraEnabled    
        public string DefinedResponseText {get; set;}
        
        @AuraEnabled    
        public string ExceptionCode {get; set;}
    
        @AuraEnabled    
        public Integer DefinedResponseOrder {get; set;}
    
        @AuraEnabled    
        public Boolean CanRemove {get; set;}
    
        @AuraEnabled    
        public string JumpToQuestion {get; set;}
       

        @AuraEnabled    
        public Boolean EndOfQuestions {get; set;}
         @AuraEnabled    
        public Boolean  IsDefinedResponseSelected {get; set;}
    
        @AuraEnabled    
        public Integer JumpToQuestionNumber {get; set;}

        @AuraEnabled    
        public List<UISelectWrapper> AllowedJumpToQuestions {get; set;}
        
        public DefinedResponseWrapper() {}

    }