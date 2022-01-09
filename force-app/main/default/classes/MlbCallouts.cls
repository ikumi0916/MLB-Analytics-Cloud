public class MlbCallouts {
    public static List<Object> TeamGetCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://lookup-service-prod.mlb.com/json/named.team_all_season.bam?sport_code=\'mlb\'&all_star_sw=\'N\'&sort_order=name_asc&season=\'2021\'');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('results:'+results);
            Map<String, Object> team_all_season = (Map<String, Object>) results.get('team_all_season');
                System.debug('team_all_season :'+team_all_season);
            Map<String, Object> queryResults = (Map<String, Object>) team_all_season.get('queryResults');
                System.debug('queryResults :'+queryResults);
            return  (List<Object>) queryResults.get('row');
        }else{
            return null;
        }
    }
    public static List<Object> Roster40MANGetCallout(String teamId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://lookup-service-prod.mlb.com/json/named.roster_40.bam?team_id=\''+ teamId + '\'');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('results:'+results);
            Map<String, Object> roster_40   = (Map<String, Object>) results.get('roster_40');
                System.debug('roster_40  :'+roster_40 );
            Map<String, Object> queryResults = (Map<String, Object>) roster_40.get('queryResults');
                System.debug('queryResults :'+queryResults);
            return  (List<Object>) queryResults.get('row');
        }else{
            return null;
        }
    }
    public static List<Object> RosterGetCallout(String teamId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://lookup-service-prod.mlb.com/json/named.roster_team_alltime.bam?start_season=\'2021\'&end_season=\'2021\'&team_id=\''+ teamId + '\'');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('results:'+results);
            Map<String, Object> roster_team_alltime  = (Map<String, Object>) results.get('roster_team_alltime');
                System.debug('roster_team_alltime  :'+roster_team_alltime );
            Map<String, Object> queryResults = (Map<String, Object>) roster_team_alltime .get('queryResults');
                System.debug('queryResults :'+queryResults);
            return  (List<Object>) queryResults.get('row');
        }else{
            return null;
        }
    }
    public static List<Object> PlayerDetailGetCallout(String playerId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://lookup-service-prod.mlb.com/json/named.player_info.bam?sport_code=\'mlb\'' + playerId);
        request.setMethod('GET');
        request.setTimeout(60000);
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('results:'+results);
            Map<String, Object> player_info  = (Map<String, Object>) results.get('player_info');
                System.debug('player_info  :'+player_info );
            Map<String, Object> queryResults = (Map<String, Object>) player_info.get('queryResults');
                System.debug('queryResults :'+queryResults);
            return  (List<Object>) queryResults.get('row');
        }else{
            return null;
        }
    }
    public static List<Object> SeasonHittingStatsGetCallout(String str) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://lookup-service-prod.mlb.com/json/named.sport_hitting_tm.bam?league_list_id=\'mlb\'&game_type=\'R\'' + str);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        List<Object> objectList = new List<Object>();
        
        if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('results:'+results);
            Map<String, Object> sport_hitting_tm  = (Map<String, Object>) results.get('sport_hitting_tm');
                System.debug('sport_hitting_tm  :'+sport_hitting_tm );
            Map<String, Object> queryResults = (Map<String, Object>) sport_hitting_tm.get('queryResults');
                System.debug('queryResults :'+queryResults);
            if(queryResults.get('totalSize') == null){
                return null;
            }
            if(queryResults.get('totalSize') == '1'){
                objectList.add(queryResults.get('row'));
            }else{
                objectList = (List<Object>) queryResults.get('row');
            }
        }
        return  objectList;
    }
    public static List<Object> SeasonPitchingStatsGetCallout(String str) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://lookup-service-prod.mlb.com/json/named.sport_pitching_tm.bam?league_list_id=|¥\'mlb\'&game_type=\'R\'' + str);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        List<Object> objectList = new List<Object>();
        
        if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('results:'+results);
            Map<String, Object> sport_hitting_tm  = (Map<String, Object>) results.get('sport_hitting_tm');
            System.debug('sport_hitting_tm  :'+sport_hitting_tm );
            Map<String, Object> queryResults = (Map<String, Object>) sport_hitting_tm.get('queryResults');
            System.debug('queryResults :'+queryResults);
            if(queryResults.get('totalSize') == null){
                return null;
            }
            if(queryResults.get('totalSize') == '1'){
                objectList.add(queryResults.get('row'));
            }else{
                objectList = (List<Object>) queryResults.get('row');
            }
        }
        return  objectList;
    }
}