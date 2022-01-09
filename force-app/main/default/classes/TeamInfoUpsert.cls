public class TeamInfoUpsert {
    public static void TeamInfoUpsert(){
        List<Object> Teams = MlbCallouts.TeamGetCallout();
        System.debug('Teams: ' + Teams);
        
        //upsert用のリスト作成
        List<Team__c> upsertList = new List<Team__c>();
        
        for(Object team : Teams){
        	Map<String, Object> t = (Map<String, Object>)team;
            Team__c teamRecord = new Team__c();
            teamRecord.team_id__c = (String)t.get('team_id');
            teamRecord.name = (String)t.get('name_display_full');
            teamRecord.franchise_code__c = (String)t.get('franchise_cSode');
            teamRecord.address_city__c = (String)t.get('address_city');
            teamRecord.store_url__c = (String)t.get('store_url');
            teamRecord.venue_name__c = (String)t.get('venue_name');
            teamRecord.name_display_full__c = (String)t.get('name');
            teamRecord.league_full__c = (String)t.get('league_full');
            teamRecord.league_id__c = (String)t.get('league_id');
            teamRecord.sport_id__c = (String)t.get('sport_id');
            upsertList.add(teamRecord);
            System.debug('teamRecord: '+teamRecord);
        }
       	if(upsertList.size() > 0 ){
        	upsert upsertList team_id__c;
        }
    }
}