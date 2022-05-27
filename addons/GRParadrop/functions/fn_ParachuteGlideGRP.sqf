/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_ParachuteGlideGRP
	Version: 		1.0
	Edited Date: 	22.05.2022
	
	Description:
		Simulate steered flight of a parachute controlled by an AI pilot
	
	Parameters:
		_pilot:			Object - pilot of parachute, defaults to objNull
		_destination:	Position array [x, y, z], defaults to []
	
	Returns:
		None
*/

// NIC_GRP_fnc_ParachuteGlideGRP = {
params [["_pilot", objNull], ["_destination", []]];
if (isNil "_pilot" || count _destination == 0) exitWith {};
if !(local _pilot) exitWith {_this remoteExecCall [NIC_GRP_fnc_ParachuteGlideGRP, _pilot]};

private [
	"_position",
	"_vectorDir",
	"_vectorUp",
	"_direction",
	"_angle",
	"_angle",
	"_pitchAngle",
	"_newPitch",
	"_bank",
	"_pitchBank",
	"_vectorDiff",
	"_newVectorUp",
	"_velocity",
	"_distance2D",
	"_height",
	"_atan",
	"_coeffXY",
	"_coeffZ",
	"_glideIndex",
	"_sinkIndex",
	"_maxSpeed"
];

private _defaultGlideIndex 	= 1.5;
private _defaultSinkIndex 	= 6;
private _defaultMaxSpeed 	= 65;
private _maxSpeed 			= _defaultMaxSpeed;
waitUntil {_pilot != vehicle _pilot};
private _parachute 			= vehicle _pilot;

while {
	_pilot != vehicle _pilot &&
	(lifeState _pilot == "HEALTHY" || lifeState _pilot == "INJURED") &&
	getPos _parachute #2 > 15
} do {
	waitUntil {!isGamePaused};
	_position 	= getPosWorld _parachute;
	_vectorDir 	= vectorDirVisual _parachute;
	_vectorUp 	= vectorUpVisual _parachute;
	_direction 	= getDirVisual _parachute;
	_angle 		= _parachute getRelDir _destination;
	_angle 		= ((_angle - 360 * floor(_angle / 180)) max - 55) min 55;
	_pitchAngle = acos(_vectorUp vectorCos [0, 0, 1]);
	_newPitch 	= _parachute getVariable ["setPitch", 0];
	_distance2D = _parachute distance2D _destination;
	
	if (time > _parachute getVariable ["nextPitch", 0]) then {
		_newPitch = random abs (25 - _newPitch);
		_parachute setVariable ["setPitch", _newPitch];
		_parachute setVariable ["nextPitch", time + 3];
		_maxSpeed = _defaultMaxSpeed;
		if (_distance2D < _defaultMaxSpeed && !(surfaceIsWater _position)) then {	// reduce speed limit near target position
			_maxSpeed = _distance2D max 20;
		};
		if (abs(_direction - (_parachute getRelDir _destination)) > 30) then {		// reduce speed limit when not flying in direction of destination
			_maxSpeed = 30;
		};
	};
	
	_pitch 			= tan _newPitch;
	_bank 			= tan - _angle;
	_pitchBank 		= vectorNormalized [_pitch * cos (90 - _direction) - _bank * sin (90 - _direction), _pitch * sin (90 - _direction) + _bank * cos (90 - _direction), 1];
	_vectorDiff		= _pitchBank vectorDiff _vectorUp;
	_vectorDiff		= VectorNormalized _vectorDiff vectorMultiply (vectorMagnitude _vectorDiff min 0.5);
	_newVectorUp	= _vectorUp vectorAdd (_vectorDiff vectorMultiply 0.01);
	_velocity 		= velocityModelSpace _parachute;
	_height			= _position select 2;
	_atan			= atan (_height / _distance2D);									// elevation angle from destination to parachute
	_coeffXY		= 0;
	_coeffZ			= 0;		
	if (_atan > 25 && _distance2D < 150) then {										// parachute is tweaked to velocity, if elevation angle is low, or not near desination
		_coeffXY = (0.6 * (_atan / 45)) min 0.6;
		_coeffZ = _coeffXY * 3;
	};
	_glideIndex	= _defaultGlideIndex + _coeffXY;
	_sinkIndex	= _defaultSinkIndex - _coeffZ;

	if (speed _parachute > _maxSpeed) then {										// let's not exceed speed limit
		_velocity set [0, (_velocity #0 + 1/10 * _angle) / _glideIndex];			// horizontal velocity
		_velocity set [1, (_velocity #1 + 1/2 * _pitchAngle) / _glideIndex];		// horizontal velocity
	};
	_velocity = _parachute vectorModelToWorldVisual _velocity;
	_velocity set [2, (_velocity #2 * 3 - 5) / _sinkIndex];							// vertical velocity

	_parachute setVelocity _velocity;
	_parachute setVectorDir ([_vectorDir, -1 / 75 * _angle * accTime] call BIS_fnc_rotateVector2D);
	_parachute setVectorUp _newVectorUp;

	sleep 0.01;
};
// };


