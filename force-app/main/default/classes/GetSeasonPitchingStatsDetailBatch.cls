public class GetSeasonPitchingStatsDetailBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    String Season = '2021';
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, player_id__c FROM player__c';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<player__c> targetRecords) {
        //player_idのSetを作成
        Set<String> playerIdSet = new Set<String>();
        String str = '';
        //引数用の文字列作成
        for(player__c player : targetRecords){
            playerIdSet.add(player.player_id__c);
            str += '&season=\'';
            str += Season;
            str += '\'';
            str += '&player_id=\'';
            str += player.player_id__c;
            str += '\'';
        }
        System.debug('str: '+str);
        //upsert用のリスト作成
        Map<String , SeasonHittingStats__c> upsertPlayerMap = new Map<String , SeasonHittingStats__c>();
        List<Object> playerHitStats = MlbCallouts.SeasonHittingStatsGetCallout(str);
        System.debug('playerHitStats: ' + playerHitStats);
        if(playerHitStats == null){
            return;
        }
        for(Object stats : playerHitStats){
            Map<String, Object> s = (Map<String, Object>)stats;
            SeasonHittingStats__c targetPlayerStats = new SeasonHittingStats__c();
            targetPlayerStats.player_id__r = new player__c(player_id__c=(String)s.get('player_id'));
            targetPlayerStats.season__c = (String)s.get('season');
            targetPlayerStats.key__c = (String)s.get('season')+ '_' + (String)s.get('player_id');
            targetPlayerStats.Name = (String)s.get('season');
            targetPlayerStats.league__c = (String)s.get('league');
            targetPlayerStats.team_abbrev__c = (String)s.get('team_abbrev');
            targetPlayerStats.ops__c = (String)s.get('ops') == '-.--'  || (String)s.get('ops') == '.---'? 0 : Decimal.valueOf((String)s.get('ops')) ;
            targetPlayerStats.ppa__c = (String)s.get('ppa') == '-.--'  || (String)s.get('ppa') == '.---'? 0 : Decimal.valueOf((String)s.get('ppa'));
            targetPlayerStats.wo__c = Decimal.valueOf((String)s.get('wo'));
            targetPlayerStats.go__c = Decimal.valueOf((String)s.get('go'));
            targetPlayerStats.go_ao__c  = (String)s.get('go_ao') == '*.**' || (String)s.get('go_ao') == '-.--'|| (String)s.get('go_ao') == '.---' ? 0 : Decimal.valueOf((String)s.get('go_ao'));
            targetPlayerStats.ao__c  = Decimal.valueOf((String)s.get('ao'));
            targetPlayerStats.so__c  = Decimal.valueOf((String)s.get('so'));
            targetPlayerStats.obp__c = (String)s.get('obp') == '-.--' || (String)s.get('obp') == '.---'? 0 : Decimal.valueOf((String)s.get('obp'));
            targetPlayerStats.bb__c = Decimal.valueOf((String)s.get('bb'));
            targetPlayerStats.tb__c = Decimal.valueOf((String)s.get('tb'));
            targetPlayerStats.h__c = Decimal.valueOf((String)s.get('h'));
            targetPlayerStats.R__c = Integer.valueOf((String)s.get('r'));
            targetPlayerStats.ab__c = Integer.valueOf((String)s.get('ab'));
            targetPlayerStats.rbi__c = Integer.valueOf((String)s.get('rbi'));
            targetPlayerStats.avg__c = (String)s.get('avg') == '-.--' || (String)s.get('avg') == '.---' ? 0 : Decimal.valueOf((String)s.get('avg'));
            targetPlayerStats.ibb__c = Integer.valueOf((String)s.get('ibb'));
            targetPlayerStats.hr__c = Integer.valueOf((String)s.get('hr'));
            targetPlayerStats.hbp__c = Integer.valueOf((String)s.get('hbp'));
            targetPlayerStats.lob__c = Integer.valueOf((String)s.get('lob'));
            targetPlayerStats.sac__c = Integer.valueOf((String)s.get('sac'));
            targetPlayerStats.sf__c = Decimal.valueOf((String)s.get('sf'));
            targetPlayerStats.sb__c = Decimal.valueOf((String)s.get('sb'));
            targetPlayerStats.cs__c = Decimal.valueOf((String)s.get('cs'));
            targetPlayerStats.tpa__c = Decimal.valueOf((String)s.get('tpa'));
            targetPlayerStats.np__c = Decimal.valueOf((String)s.get('np'));
            targetPlayerStats.g__c = Decimal.valueOf((String)s.get('g'));
            targetPlayerStats.xbh__c = Decimal.valueOf((String)s.get('xbh'));
            targetPlayerStats.slg__c = (String)s.get('slg') == '-.--'  || (String)s.get('slg') == '.---'? 0 : Decimal.valueOf((String)s.get('slg'));
            upsertPlayerMap.put(targetPlayerStats.player_id__c, targetPlayerStats);
            System.debug('targetPlayerStats: '+targetPlayerStats);
        }
        if(upsertPlayerMap.size() > 0 ){
            upsert upsertPlayerMap.values() key__c;
        }
    }
    public void finish(Database.BatchableContext bc) {
    }
}