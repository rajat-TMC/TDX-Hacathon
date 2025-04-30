@RestResource(urlMapping='/telematics/create')
global with sharing class Webhook_CreateTelematicData {
    
    @HttpPost
    global static String createTelematics() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            // Parse the incoming JSON body into a wrapper object
            TelematicsWrapper incomingData = (TelematicsWrapper) JSON.deserialize(req.requestBody.toString(), TelematicsWrapper.class);
            
            // Create new Telematics__c record
            Auto_Telematics__c tele = new Auto_Telematics__c();
            tele.Vehicle__c = incomingData.VehicleId;
            tele.Air_Con_Status__c = incomingData.AirConStatus;
            tele.Battery_Charge_Cycles__c = incomingData.BatteryChargeCycle;
            tele.Battery_Charge_Status__c = incomingData.BatteryChargeStatus;
            tele.Battery_Coolant_Level_Status__c = incomingData.BatteryCoolantLevelStatus;
            tele.Battery_Current_Charge__c = incomingData.BatteryCurrentCharge;
            tele.Battery_Last_Charge_Date__c = incomingData.BatteryLastChargeDate;
            tele.Battery_Temperature__c = incomingData.BatteryTemperature;
            tele.Brake_Fluid_Status__c = incomingData.BrakeFluidStatus;
            tele.Brake_Status__c = incomingData.BrakeStatus;
            tele.Cabin_Air_Status__c = incomingData.CabinAirStatus;
            tele.Current_Mileage__c = incomingData.CurrentMileage;
            tele.Current_Speed__c = incomingData.CurrentSpeed;
            tele.Door_Lock_Status__c = incomingData.DoorLockStatus;
            tele.Front_Left_Tire_Pressure__c = incomingData.FrontLeftTirePressure;
            tele.Front_Right_Tire_Pressure__c = incomingData.FrontRightTirePressure;
            tele.Fuel_Last_Refill_Date__c = incomingData.FuelLastRefillDate;
            tele.Fuel_Level__c = incomingData.FuelLevel;
            tele.Headlamp_Status__c = incomingData.HeadlampStatus;
            tele.Oil_Status__c = incomingData.OilStatus;
            tele.Reading_Date_Time__c = incomingData.ReadingDateTime;
            tele.Rear_Left_Tire_Pressure__c = incomingData.RearLeftTirePressure;
            tele.Rear_Right_Tire_Pressure__c = incomingData.RearRightTirePressure;
            tele.Tire_Pressure_Status__c = incomingData.TirePressureStatus;
            tele.Transmission_Fluid_Status__c = incomingData.TransmissionFluidStatus;
            tele.Washer_Fluid_Status__c = incomingData.WasherFluidStatus;
            tele.Location__Latitude__s = parseDecimal(incomingData.Latitude);
            tele.Location__Longitude__s = parseDecimal(incomingData.Logitude);
            
            
            insert tele;
            
            RecordAlert rdAlert = new RecordAlert();
            rdAlert.Subject ='Collision';
            rdAlert.EffectiveDate = system.now();
            rdAlert.ValidUntilDate = system.now().adddays(1);
            rdAlert.WhatId = incomingData.VehicleId;
            rdAlert.ParentId = '003dL00000VQYUxQAP';
            rdAlert.Latitude__c = incomingData.Latitude;
            rdAlert.Longitude__c = incomingData.Logitude;
            rdAlert.IsActive = true;
            insert rdAlert;
            res.statusCode = 201;
            return 'Telematics record created with Id: ' + rdAlert.Id;
            
        } catch (Exception ex) {
            res.statusCode = 400;
            return 'Error: ' + ex.getMessage();
        }
    }
    
    // Parse ISO date string to DateTime safely
    private static Datetime parseDateTime(String dateStr) {
        try {
            return Datetime.valueOfGmt(dateStr);
        } catch (Exception e) {
            return null;
        }
    }
    
    // Parse to Decimal
    private static Decimal parseDecimal(String value) {
        try {
            return Decimal.valueOf(value);
        } catch (Exception e) {
            return null;
        }
    }
    
    
    // Define the wrapper class to map incoming JSON
    global class TelematicsWrapper {
        public String VehicleId;//Vehicle__c
        public String AirConStatus;//Air_Con_Status__c
        public Integer BatteryChargeCycle;//Battery_Charge_Cycles__c
        public String BatteryChargeStatus;//Battery_Charge_Status__c
        public String BatteryCoolantLevelStatus;//Battery_Coolant_Level_Status__c
        public Integer BatteryCurrentCharge;//Battery_Current_Charge__c
        public Date BatteryLastChargeDate;//Battery_Last_Charge_Date__c
        public Integer BatteryTemperature;//Battery_Temperature__c
        public String BrakeFluidStatus;//Brake_Fluid_Status__c
        public String BrakeStatus;//Brake_Status__c
        public String CabinAirStatus;//Cabin_Air_Status__c
        public Integer CurrentMileage;//Current_Mileage__c
        public Integer CurrentSpeed;//Current_Speed__c
        public String DoorLockStatus;//Door_Lock_Status__c
        public Integer FrontLeftTirePressure;//Front_Left_Tire_Pressure__c
        public Integer FrontRightTirePressure;//Front_Right_Tire_Pressure__c
        public Date FuelLastRefillDate;//Fuel_Last_Refill_Date__c
        public Integer FuelLevel;//Fuel_Level__c
        public String HeadlampStatus;//Headlamp_Status__c
        public String OilStatus;//Oil_Status__c
        public DateTime ReadingDateTime;//Reading_Date_Time__c
        public Integer RearLeftTirePressure;//Rear_Left_Tire_Pressure__c
        public Integer RearRightTirePressure;//Rear_Right_Tire_Pressure__c
        public String TirePressureStatus;//Tire_Pressure_Status__c
        public String TransmissionFluidStatus;//Transmission_Fluid_Status__c
        public String WasherFluidStatus;//Washer_Fluid_Status__c
        public String Logitude;//Location__r.Longitude
        public String Latitude;//Location__r.Latitude
    }
}