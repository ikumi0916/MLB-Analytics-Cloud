public class Get40ManRoaster {
    public static void Get40ManRoaster(){
        //チームレコードを一括取得
        List<Team__c> teamRecordList = [SELECT 
                                       	Id,
                                       	team_id__c
                                       FROM
                                       	Team__c];
        //team_idのSetを作成
        Set<String> teamIdSet = new Set<String>();
        for(Team__c team : teamRecordList){
            teamIdSet.add(team.team_id__c);
        }
        
        //現時点の40-MAN ROSTERレコードを取得
        Map<String,X40_MAN_ROSTER__c> existRoaterMap = new Map<String,X40_MAN_ROSTER__c>();
        for(X40_MAN_ROSTER__c existRoater : [SELECT id, Team__r.team_id__c, Player__r.player_id__c FROM X40_MAN_ROSTER__c]){
            existRoaterMap.put(existRoater.Team__r.team_id__c+'_'+existRoater.Player__r.player_id__c, existRoater);
        }
        //ロースター除外用のリスト
        List<X40_MAN_ROSTER__c> deleteRoater = new List<X40_MAN_ROSTER__c>();
        //insertMap作成
        Map<String,X40_MAN_ROSTER__c> insertPlayerMap = new Map<String,X40_MAN_ROSTER__c>();
        //continuMap作成
        Map<String,X40_MAN_ROSTER__c> continuePlayerMap = new Map<String,X40_MAN_ROSTER__c>();
        
        for(String id : teamIdSet){
        	List<Object> rosterPlayers = MlbCallouts.Roster40MANGetCallout(id);
            System.debug('rosterPlayers: ' + rosterPlayers);

        	for(Object player : rosterPlayers){
        		Map<String, Object> p = (Map<String, Object>)player;
                X40_MAN_ROSTER__c  targetPlayer = new X40_MAN_ROSTER__c ();
                targetPlayer.Name = (String)p.get('name_display_first_last')+'_'+(String)p.get('team_abbrev');
                targetPlayer.Team__r = new Team__c(team_id__c=(String)p.get('team_id'));
                targetPlayer.Player__r = new player__c(player_id__c=(String)p.get('player_id'));
                //既存のロースターと同じ選手がいる場合は、リストから除外
                if(existRoaterMap.containsKey((String)p.get('team_id')+'_'+(String)p.get('player_id'))){
                    continuePlayerMap.put((String)p.get('team_id')+'_'+(String)p.get('player_id'),targetPlayer);
                    continue;
                }
                insertPlayerMap.put((String)p.get('team_id')+'_'+(String)p.get('player_id'),targetPlayer);
            }
            //ロースター除外の選手の洗い出し
            for(String existKey :existRoaterMap.keyset()){
                if(continuePlayerMap.containsKey(existKey) != false && insertPlayerMap.containsKey(existKey) != false){
                    deleteRoater.add(existRoaterMap.get(existKey));
                }
            }
        }
        insert insertPlayerMap.values();
    }
}