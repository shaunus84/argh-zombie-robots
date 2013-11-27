package com.culpritgames.zombies.maths 
{
    /**
     * A 2d Vector class to that is mutable.
     * 
     * Due to the lack of AS3 operator overloading most methods exists in different names,
     * all methods that ends with Self actually modifies the object itself (including obvious ones copy, copyXY and zero).
     * For example v1 += v2; is written as v1.addSelf(v2);
     * 
     * The class in not commented properly yet - just subdivided into logical chunks.
     * 
     * @author playchilla.com
     *
     * License: Use it as you wish and if you like it - link back!
     */
    public class Vec2 extends Vec2Const
    {
        public static const Zero:Vec2Const = new Vec2Const;
        public static const Epsilon:Number = 0.0000001;
        public static const EpsilonSqr:Number = Epsilon * Epsilon;
         
        public static function createRandomDir():Vec2
        {
            const rads:Number = Math.random() * Math.PI * 2;
            return new Vec2(Math.cos(rads), Math.sin(rads));
        }
         
        public function Vec2(x:Number = 0, y:Number = 0) { super(x, y); }
         
        /**
         * Copy / assignment
         */
        public function set x(x:Number):void { _x = x; }
        public function set y(y:Number):void { _y = y; }
 
        public function copy(pos:Vec2Const):Vec2
        {
            _x = pos._x;
            _y = pos._y;
            return this;
        }
        public function copyXY(x:Number, y:Number):Vec2
        {
            _x = x;
            _y = y;
            return this;
        }
        public function zero():Vec2
        {
            _x = 0;
            _y = 0;
            return this;
        }
 
        /**
         * Add
         */
        public function addSelf(pos:Vec2Const):Vec2
        {
            _x += pos._x;
            _y += pos._y;
            return this;
        }       
        public function addXYSelf(x:Number, y:Number):Vec2
        {
            _x += x;
            _y += y;
            return this;
        }
 
        /**
         * Sub
         */    
        public function subSelf(pos:Vec2Const):Vec2
        {
            _x -= pos._x;
            _y -= pos._y;
            return this;
        }
        public function subXYSelf(x:Number, y:Number):Vec2
        {
            _x -= x;
            _y -= y;
            return this;
        }
 
        /**
         * Mul
         */
        public function mulSelf(vec:Vec2Const):Vec2
        {
            _x *= vec._x;
            _y *= vec._y;
            return this;
        }
        public function mulXYSelf(x:Number, y:Number):Vec2
        {
            _x *= x;
            _y *= y;
            return this;
        }
 
        /**
         * Div
         */
        public function divSelf(vec:Vec2Const):Vec2
        {
            _x /= vec._x;
            _y /= vec._y;
            return this;
        }
        public function divXYSelf(x:Number, y:Number):Vec2
        {
            _x /= x;
            _y /= y;
            return this;
        }
 
        /**
         * Scale
         */    
        public function scaleSelf(s:Number):Vec2
        {
            _x *= s;
            _y *= s;
            return this;
        }
 
        public function rescaleSelf(newLength:Number):Vec2
        {
            const nf:Number = newLength / Math.sqrt(_x * _x + _y * _y);
            _x *= nf;
            _y *= nf;
            return this;
        }
         
        /**
         * Normalize
         */
        public function normalizeSelf():Vec2
        {
            const nf:Number = 1 / Math.sqrt(_x * _x + _y * _y);
            _x *= nf;
            _y *= nf;
            return this;
        }
 
        /**
         * Rotate
         */
        public function rotateSelf(rads:Number):Vec2
        {
            const s:Number = Math.sin(rads);
            const c:Number = Math.cos(rads);
            const xr:Number = _x * c - _y * s;
            _y = _x * s + _y * c;
            _x = xr;
            return this;
        }
        public function normalRightSelf():Vec2
        {
            const xr:Number = _x;
            _x = -_y
            _y = xr;
            return this;
        }
        public function normalLeftSelf():Vec2
        {
            const xr:Number = _x;
            _x = _y
            _y = -xr;
            return this;
        }
        public function negateSelf():Vec2
        {
            _x = -_x;
            _y = -_y;
            return this;
        }
         
        /**
         * Spinor
         */
        public function rotateSpinorSelf(vec:Vec2Const):Vec2
        {
            const xr:Number = _x * vec._x - _y * vec._y;
            _y = _x * vec._y + _y * vec._x;
            _x = xr;
            return this;
        }
         
        /**
         * lerp
         */
        public function lerpSelf(to:Vec2Const, t:Number):Vec2
        {
            _x = _x + t * (to._x - _x);
            _y = _y + t * (to._y - _y);
            return this;
        }
 
        /**
         * Helpers
         */
        public static function swap(a:Vec2, b:Vec2):void
        {
            const x:Number = a._x;
            const y:Number = a._y;
            a._x = b._x;
            a._y = b._y;
            b._x = x;
            b._y = y;
        }
    }
}