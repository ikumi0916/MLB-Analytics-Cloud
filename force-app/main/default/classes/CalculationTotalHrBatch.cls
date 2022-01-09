public class CalculationTotalHrBatch implements Database.Batchable<sObject>, Database.Stateful {
    String Season = '2021';
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, player_id__c, name_display_first_last__c FROM player__c';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<player__c> targetRecords) {
        Set<String> playerIdSet = new Set<String>();
        for(player__c p : targetRecords){
            playerIdSet.add(p.player_id__c);
        }
        List<DailyHittingStats__c> upsertDailyHitting = new  List<DailyHittingStats__c>();
        List<player__c> playerList = [SELECT name_display_first_last__c,(SELECT id, HR__c, TotalHR__c, Date__c, Season__c FROM DailyBat_Player__r ORDER BY Date__c) FROM player__c WHERE player_id__c IN: playerIdSet ];
        for(player__c p : playerList){
			List<DailyHittingStats__c> dailyHitting = p.DailyBat_Player__r;
            if(dailyHitting.isEmpty()){
                continue;
            }
            Decimal totalHr = 0;
            for(DailyHittingStats__c h : dailyHitting){
                if(h.Season__c != Season){
                    continue;
                }
                totalHr += h.HR__c;
                h.TotalHR__c = totalHr;
                upsertDailyHitting.add(h);
            }
        }
        upsert upsertDailyHitting;
    }
    public void finish(Database.BatchableContext bc) {
    }
}