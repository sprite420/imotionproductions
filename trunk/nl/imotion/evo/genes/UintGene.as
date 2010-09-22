/*
 * Licensed under the MIT license
 *
 * Copyright (c) 2010 Pieter van de Sluis
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * http://code.google.com/p/imotionproductions/
 */

package nl.imotion.evo.genes
{
    /**
     * @author Pieter van de Sluis
     * Date: 14-sep-2010
     * Time: 21:29:02
     */
    public class UintGene extends Gene
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _minVal:uint;

        private var _maxVal:uint;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function UintGene( propName:String, value:Number, variation:Number, minVal:uint, maxVal:uint, limitMethod:String = "bounce" ):void
        {
            _minVal = minVal;
            _maxVal = maxVal;

            super( propName, value, variation, limitMethod );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function getValue():*
        {
            return _minVal + Math.floor( value * ( ( _maxVal + 0.99999999 - _minVal ) ) );
        }


        override public function clone():Gene
        {
            return new UintGene( propName, value, mutationEffect, _minVal, _maxVal, limitMethod );
        }


        override public function toXML():XML
        {
            var xml:XML = super.toXML();

            xml[ "@type" ]      = "uint";
            xml[ "@minVal" ]    = minVal;
            xml[ "@maxVal" ]    = maxVal;

            return xml;
        }


        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get minVal():uint
        {
            return _minVal;
        }


        public function set minVal( value:uint ):void
        {
            _minVal = value;
        }


        public function get maxVal():uint
        {
            return _maxVal;
        }


        public function set maxVal( value:uint ):void
        {
            _maxVal = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS



    }
}