package unit4399.events{
    import flash.events.Event;

    public class UnionEvent extends Event {
 
	    public static const UNION_VISITOR_SUCCESS:String = "unionVisitorSuccess"; 
	    public static const UNION_MEMBER_SUCCESS:String = "unionMemberSuccess"; 
	    public static const UNION_MASTER_SUCCESS:String = "unionMasterSuccess"; 
	    public static const UNION_GROW_SUCCESS:String = "unionGrowSuccess";
	    public static const UNION_VARIABLES_SUCCESS:String = "unionVariablesSuccess";
	    public static const UNION_ERROR:String = "unionError";
	    //游客
	    public static const UNI_API_BHCJ:String = "create_union";	
		public static const UNI_API_BHLB:String = "list_union";	
		public static const UNI_API_BHSQ:String = "apply_union";
		public static const UNI_API_SSBH:String = "own_union";
	    //成员 
		public static const UNI_API_BHMX:String = "union_detail";
		public static const UNI_API_BHCY:String = "member_list";
		public static const UNI_API_CYTZBG:String = "member_extra_change";
		public static const UNI_API_BHTZBG:String = "union_extra_change";
		public static const UNI_API_BHRZ:String = "union_log";
		public static const UNI_API_XHGRGXD:String = "use_pesonal_contribution";
		public static const UNI_API_TCBH:String = "quit_union";
		
		//成长
		public static const UNI_API_BHRW:String = "union_task";
		public static const UNI_API_BHRWWC:String = "union_task_complete";
		public static const UNI_API_BHDH:String = "union_exchange";
		//帮主
		public static const UNI_API_DSHLB:String = "union_apply_list";
		public static const UNI_API_CYSH:String = "union_member_audit";
		public static const UNI_API_CYYC:String = "union_remove_member";
		public static const UNI_API_JSBH:String = "union_dissolve";
		public static const UNI_API_XHBHGXD:String = "use_union_contribution";
		public static const UNI_API_SHDGCY:String = "union_multi_member_audit";
		public static const UNI_API_ZRBH:String = "union_transfer";
		//公共变量
		public static const UNI_API_HQBL:String = "get_variables";
		public static const UNI_API_XGBL:String = "change_variable";
		
        protected var _data:Object;
		
        public function UnionEvent(type:String, dataOb:Object=null, bubbles:Boolean=false, cancelable:Boolean=false){
            super(type, bubbles, cancelable);
            _data = dataOb;
        }
		
        public function get data():Object{
            return _data;
        }
        
        override public function clone():Event{
            return new UnionEvent(type, data, bubbles, cancelable);
        }
	}
}
