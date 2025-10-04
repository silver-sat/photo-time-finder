startTime = datetime("today","TimeZone","UTC");
duration = days(14);
endTime = startTime + duration;

step = 60;

sc = satelliteScenario(startTime, endTime, step);
viewer = satelliteScenarioViewer(sc, "Dimension","3D");

iss = satellite(sc, "ISS.tle", "Name","ISS");

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

gLat = 38.9961;
gLon = -77.0281;
gstation = groundStation(sc,gLat,gLon, "Name","Ground Station");

antena = gimbal(gstation);
pointAt(antena, [38.9961;-77.0281;1000])
antenaView = conicalSensor(antena, "MaxViewAngle",120);
fieldOfView(antenaView)

target_poses = [43.4317231, -83.9592416; 39.1643136, -76.9032192];
targets = [];

tLat = 43.4317231;
tLon = -83.9592416;
target = groundStation(sc,tLat,tLon, "Name","Target");

acTarget = access(camera,target);
tTarget = accessIntervals(acTarget)

acGSattion = access(antenaView,iss);
tGStation = accessIntervals(acGSattion)

play(sc)
