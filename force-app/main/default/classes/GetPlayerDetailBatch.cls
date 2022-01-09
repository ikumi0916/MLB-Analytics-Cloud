public class GetPlayerDetailBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    public Database.QueryLocator start(Database.BatchableContext bc) {
    String query = 'SELECT Id, player_id__c FROM player__c';
    return Database.getQueryLocator(query);
	}
    public void execute(Database.BatchableContext bc, List<player__c> targetRecords) {
        //player_idのSetを作成
        Set<String> playerIdSet = new Set<String>();
        String playerIdStr = '';
        //引数用の文字列作成
        for(player__c player : targetRecords){
            playerIdSet.add(player.player_id__c);
            playerIdStr += '&player_id=\'';
            playerIdStr += player.player_id__c;
            playerIdStr += '\'';
        }
        //upsert用のリスト作成
        Map<String , player__c> upsertPlayerMap = new Map<String , player__c>();
        List<Object> playerDetail = MlbCallouts.PlayerDetailGetCallout(playerIdStr);
        System.debug('playerDetail: ' + playerDetail);
        
        for(Object player : playerDetail){
            Map<String, Object> p = (Map<String, Object>)player;
            player__c targetPlayer = new player__c();
            targetPlayer.player_id__c = (String)p.get('player_id');
            targetPlayer.position__c = (String)p.get('primary_position_txt');
            targetPlayer.bats__c = (String)p.get('bats');
            targetPlayer.Name = (String)p.get('name_display_first_last');
            targetPlayer.name_display_first_last__c = (String)p.get('name_display_first_last');
            targetPlayer.throws__c = (String)p.get('throws');
            targetPlayer.weight__c  = Decimal.valueOf((String)p.get('weight'));
            targetPlayer.height_feet__c  = Decimal.valueOf((String)p.get('height_feet'));
            targetPlayer.height_inches__c  = Decimal.valueOf((String)p.get('height_inches'));
            String birth_date = (String)p.get('birth_date');
            if(!String.isBlank(birth_date))targetPlayer.birth_date__c = Date.valueOf(birth_date.left(10));
            String pro_debut_date = (String)p.get('pro_debut_date');
            if(!String.isBlank(pro_debut_date))targetPlayer.pro_debut_date__c = Date.valueOf(pro_debut_date.left(10));
            targetPlayer.age__c = Decimal.valueOf((String)p.get('age'));
            targetPlayer.high_school__c = (String)p.get('high_school');
            targetPlayer.college__c =(String)p.get('college');
            targetPlayer.birth_country__c =(String)p.get('birth_country');
            upsertPlayerMap.put(targetPlayer.player_id__c, targetPlayer);
            System.debug('targetPlayer: '+targetPlayer);
        }
        if(upsertPlayerMap.size() > 0 ){
            upsert upsertPlayerMap.values() player_id__c;
        }
        
    }
    public void finish(Database.BatchableContext bc) {
        //名前が重複している選手にチーム名を付与
        List<AggregateResult> targetPlayer = [SELECT Count(Id),name_display_first_last__c FROM player__c GROUP BY name_display_first_last__c  HAVING Count(Id) > 1];
        List<String> targetPlayerName = new List<String>();
        for(AggregateResult aList : targetPlayer){
            targetPlayerName.add((String)aList.get('name_display_first_last__c'));
        }
        List<player__c> updatePlayer = [SELECT Id , name_display_first_last__c , player_id__c FROM player__c WHERE name_display_first_last__c IN :targetPlayerName];
        for(player__c p : updatePlayer){
            p.name_display_first_last__c = p.name_display_first_last__c + '_' + p.player_id__c;
        }
        update updatePlayer;
	}
}