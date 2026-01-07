startTime = datetime("today","TimeZone","UTC");
duration = days(7);
endTime = startTime + duration;

step = 60;

sc = satelliteScenario(startTime, endTime, step);
viewer = satelliteScenarioViewer(sc, "Dimension","3D");

iss = satellite(sc, "SilverSat.tle", "Name","SilverSat");

[pos,vel,timeOut] = states(iss,"CoordinateFrame","geographic");

decimalYear = 2025.0;
[XYZ,H,D,I,F,DXDYDZ,DH,DD,DI,DF] = igrfmagm(pos(3,:),pos(1,:),pos(2,:),decimalYear*ones(size(pos(3,:))));
Zangle = D'; 
Yangle = 90-I';  
Xangle = 0*ones(size(Zangle));
angles = [Zangle;Yangle;Xangle]';
TT = timetable(timeOut',angles);

timeTable = timetable(timeOut', angles);
pointAt(iss,timeTable,"CoordinateFrame","ned","Format","euler");

camera = conicalSensor(iss,"MaxViewAngle",70); % I think
fieldOfView(camera,"LineColor",[1 0 1]);

gLat = 51.7383;
gLon = 19.8196;
gstation = groundStation(sc,gLat,gLon, "Name","Ground Station");

antena = gimbal(gstation);
pointAt(antena, [38.9961;-77.0281;1000])
antenaView = conicalSensor(antena, "MaxViewAngle",179);
fieldOfView(antenaView)

target_poses = readmatrix('PhotoPoses.txt');

for pos = 1:length(target_poses)
    tLat=target_poses(pos, 1);
    tLon=target_poses(pos, 2);
    target = groundStation(sc,tLat,tLon, "Name","Target");
    acTarget = access(camera,target);
    tTarget = accessIntervals(acTarget);
    writetable(tTarget,'times'+string(pos)+'.txt','Delimiter',' ')
end

acGSattion = access(antenaView,iss);
tGStation = accessIntervals(acGSattion)

play(sc)
