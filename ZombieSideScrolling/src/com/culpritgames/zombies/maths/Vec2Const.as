package com.culpritgames.zombies.maths
{
    /**
     * A 2d Vector class to perform constant operations. Use this class to make sure that objects stay consts, e.g.
     * public function getPos():Vec2Const { return _pos; } // pos is not allowed to change outside of bot.
     *
     * Many method has a postfix of XY - this allows you to operate on the components directly i.e.
     * instead of writing add(new Vec2(1, 2)) you can directly write addXY(1, 2);
     *
     * For performance reasons I am not using an interface for read only specification since internally it should be possible
     * to use direct access to x and y. Externally x and y is obtained via getters which are a bit slower than direct access of
     * a public variable. I suggest you stick with this during development. If there is a bottleneck you can just remove the get
     * accessors and directly expose _x and _y (rename it to x and replace all _x and _y to this.x, this.y internally).
     *
     * The class in not commented properly yet - just subdivided into logical chunks.
     *
     * @author playchilla.com
     *
     * License: Use it as you wish and if you like it - link back!
     */
    public class Vec2Const
    {
		internal var _x:Number;
        internal var _y:Number;
		
        public function get x():Number { return _x; }
        public function get y():Number { return _y; }
         
        public function Vec2Const(x:Number = 0, y:Number = 0)
        {
            _x = x;
            _y = y;
        }
         
        public function clone():Vec2 { return new Vec2(_x, _y); }
         
        /**
         * Add, sub, mul and div
         */
        public function add(pos:Vec2Const):Vec2 { return new Vec2(_x + pos._x, _y + pos._y); }
        public function addXY(x:Number, y:Number):Vec2 { return new Vec2(_x + x, _y + y); }
         
        public function sub(pos:Vec2Const):Vec2 { return new Vec2(_x - pos._x, _y - pos._y); }
        public function subXY(x:Number, y:Number):Vec2 { return new Vec2(_x - x, _y - y); }
         
        public function mul(vec:Vec2Const):Vec2 { return new Vec2(_x * vec._x, _y * vec._y); }
        public function mulXY(x:Number, y:Number):Vec2 { return new Vec2(_x * x, _y * y); }
         
        public function div(vec:Vec2Const):Vec2 { return new Vec2(_x / vec._x, _y / vec._y); }
        public function divXY(x:Number, y:Number):Vec2 { return new Vec2(_x / x, _y / y); }
         
        /**
         * Scale
         */
        public function scale(s:Number):Vec2 { return new Vec2(_x * s, _y * s); }
         
        public function rescale(newLength:Number):Vec2
        {
            const nf:Number = newLength / Math.sqrt(_x * _x + _y * _y);
            return new Vec2(_x * nf, _y * nf);
        }
 
        /**
         * Normalize
         */
        public function normalize():Vec2
        {
            const nf:Number = 1 / Math.sqrt(_x * _x + _y * _y);
            return new Vec2(_x * nf, _y * nf);
        }
 
        /**
         * Distance
         */
        public function length():Number { return Math.sqrt(_x * _x + _y * _y); }
        public function lengthSqr():Number { return _x * _x + _y * _y; }
        public function distance(vec:Vec2Const):Number
        {
            const xd:Number = _x - vec._x;
            const yd:Number = _y - vec._y;
            return Math.sqrt(xd * xd + yd * yd);
        }
        public function distanceXY(x:Number, y:Number):Number
        {
            const xd:Number = _x - x;
            const yd:Number = _y - y;
            return Math.sqrt(xd * xd + yd * yd);
        }
        public function distanceSqr(vec:Vec2Const):Number
        {
            const xd:Number = _x - vec._x;
            const yd:Number = _y - vec._y;
            return xd * xd + yd * yd;
        }
        public function distanceXYSqr(x:Number, y:Number):Number
        {
            const xd:Number = _x - x;
            const yd:Number = _y - y;
            return xd * xd + yd * yd;
        }
 
        /**
         * Queries.
         */
        public function equals(vec:Vec2Const):Boolean { return _x == vec._x && _y == vec._y; }
        public function equalsXY(x:Number, y:Number):Boolean { return _x == x && _y == y; }
        public function isNormalized():Boolean { return Math.abs((_x * _x + _y * _y)-1) < Vec2.EpsilonSqr; }
        public function isZero():Boolean { return _x == 0 && _y == 0; }
        public function isNear(vec2:Vec2Const):Boolean { return distanceSqr(vec2) < Vec2.EpsilonSqr; }
        public function isNearXY(x:Number, y:Number):Boolean { return distanceXYSqr(x, y) < Vec2.EpsilonSqr; }
        public function isWithin(vec2:Vec2Const, epsilon:Number):Boolean { return distanceSqr(vec2) < epsilon*epsilon; }
        public function isWithinXY(x:Number, y:Number, epsilon:Number):Boolean { return distanceXYSqr(x, y) < epsilon*epsilon; }
        public function isValid():Boolean { return !isNaN(_x) && !isNaN(_y) && isFinite(_x) && isFinite(_y); }
        public function getDegrees():Number { return getRads() * _RadsToDeg; }
        public function getRads():Number { return Math.atan2(_y, _x); }
        public function getRadsBetween(vec:Vec2Const):Number { return Math.atan2(x - vec.x, y - vec.y);}
         
        /**
         * Dot product
         */
        public function dot(vec:Vec2Const):Number { return _x * vec._x + _y * vec._y; }
        public function dotXY(x:Number, y:Number):Number { return _x * x + _y * y; }
         
        /**
         * Cross determinant
         */
        public function crossDet(vec:Vec2Const):Number { return _x * vec._y - _y * vec._x; }
        public function crossDetXY(x:Number, y:Number):Number { return _x * y - _y * x; }
 
        /**
         * Rotate
         */
        public function rotate(rads:Number):Vec2
        {
            const s:Number = Math.sin(rads);
            const c:Number = Math.cos(rads);
            return new Vec2(_x * c - _y * s, _x * s + _y * c);
        }
        public function normalRight():Vec2 { return new Vec2(-_y, _x); }
        public function normalLeft():Vec2 { return new Vec2(_y, -_x); }
        public function negate():Vec2 { return new Vec2( -_x, -_y); }
         
        /**
         * Spinor rotation
         */
        public function rotateSpinorXY(x:Number, y:Number):Vec2 { return new Vec2(_x * x - _y * y, _x * y + _y * x); }
        public function rotateSpinor(vec:Vec2Const):Vec2 { return new Vec2(_x * vec._x - _y * vec._y, _x * vec._y + _y * vec._x); }
        public function spinorBetween(vec:Vec2Const):Vec2
        {
            const d:Number = lengthSqr();
            const r:Number = (vec._x * _x + vec._y * _y) / d;
            const i:Number = (vec._y * _x - vec._x * _y) / d;
            return new Vec2(r, i);
        }
 
        /**
         * Lerp / slerp
         * Note: Slerp is not well tested yet.
         */
        public function lerp(to:Vec2Const, t:Number):Vec2 { return new Vec2(_x + t * (to._x - _x), _y + t * (to._y - _y)); }
         
        public function slerp(vec:Vec2Const, t:Number):Vec2
        {
            const cosTheta:Number = dot(vec);
            const theta:Number = Math.acos(cosTheta);
            const sinTheta:Number = Math.sin(theta);
            if (sinTheta <= Vec2.Epsilon)
                return vec.clone();
            const w1:Number = Math.sin((1 - t) * theta) / sinTheta;
            const w2:Number = Math.sin(t * theta) / sinTheta;
            return scale(w1).add(vec.scale(w2));
        }
 
        /**
         * Reflect
         */
        public function reflect(normal:Vec2Const):Vec2
        {
            const d:Number = 2 * (_x * normal._x + _y * normal._y);
            return new Vec2(_x - d * normal._x, _y - d * normal._y);
        }
 
        /**
         * String
         */
        public function toString():String { return "[" + _x + ", " + _y + "]"; }
         
        public function getMin(p:Vec2Const):Vec2 { return new Vec2(Math.min(p._x, _x), Math.min(p._y, _y)); }
        public function getMax(p:Vec2Const):Vec2 { return new Vec2(Math.max(p._x, _x), Math.max(p._y, _y)); }
         
        private static const _RadsToDeg:Number = 180 / Math.PI;
    }
}