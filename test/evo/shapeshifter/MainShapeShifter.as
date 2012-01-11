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

package test.evo.shapeshifter
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.utils.getTimer;

    import nl.imotion.utils.momentum.MomentumCalculator;

    import test.evo.*;


    /**
     * @author Pieter van de Sluis
     * Date: 19-sep-2010
     * Time: 19:47:55
     */
    [SWF(backgroundColor="#000000",width="1024",height="700",frameRate="31")]
    public class MainShapeShifter extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var firstEvo:IEvolver;

        private var targetPopulationFitness:Number = 0.99;
        private var minGenerationMomentum:Number = 0.0001;

        private var populationFitness:Number;

        private var sourceImg:Bitmap;

        private var holder:Sprite;
        private var layer:Sprite;

        private var startTime:Number;

        private var numGenerations:uint = 0;

        private var numPopulations:uint = 1;
        private var maxNumPopulations:uint = 20;

        private var numEvos:uint = 0;
        private var minSize:uint = 0;
        private var maxSize:uint = 0;

        private var startMinSize:Number = 25;
        private var startMaxSize:Number = 30;
        private var endMinSize:Number = 3;
        private var endMaxSize:Number = 5;

        private var startEvos:uint = 350;
        private var endEvos:uint = 500;

        private var evoList:/*IEvolver*/Array = [];

        private var momentumCalc:MomentumCalculator;

        private var _displayEnabled:Boolean = true;
        private var _btDisplay:Sprite;


        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function MainShapeShifter()
        {
            sourceImg = new Bitmap( new Pieter() as BitmapData );
            sourceImg.x = 100 + sourceImg.width + 50;
            sourceImg.y = 50;
//            this.addChild( sourceImg );

            holder = new Sprite();
//            holder.graphics.beginFill( 0x0000ff, 1 )
//            holder.graphics.lineStyle( 1, 0xffffff );
//            holder.graphics.drawRect(0,0,sourceImg.width,sourceImg.height);
            holder.x = holder.y = 50;
            this.addChild( holder );
            /*

             var evo:ShapeShifterEvolver = new ShapeShifterEvolver(sourceImg.width,sourceImg.height);
             evo.reset( 80, 80);

             var res:Bitmap = evo.draw();
             var c:ColorTransform = res.transform.colorTransform;
             c.color = 0xff0000;
             res.transform.colorTransform = c;

             holder.addChild( res )

             holder.addChild(evo.container);
             evo.container.alpha = 1;*/

            _btDisplay = new Sprite();
            _btDisplay.buttonMode = true;
            _btDisplay.graphics.beginFill( 0x000077 )
            _btDisplay.graphics.drawCircle( stage.stageWidth - 50, stage.stageHeight - 50, 20 );
            _btDisplay.addEventListener( MouseEvent.CLICK, btDisplayHandler )
            this.addChild( _btDisplay );

            numEvos = startEvos;
            minSize = startMinSize;
            maxSize = startMaxSize;

            firstEvo = new ShapeShifterEvolver( sourceImg.width, sourceImg.height );
            evoList[ 0 ] = firstEvo;

            resetAndCreateEvos();

            startTime = getTimer();

//            var s:ShapeShifter = new ShapeShifter();
//            s.update();
//            holder.addChild(s)

//            evolve();

            momentumCalc = new MomentumCalculator( 8 );

            addEventListener( Event.ENTER_FRAME, enterFrameHandler );
        }


        public function getValue( minVal:int, maxVal:int ):int
        {

//            return minVal + Math.round( Math.random() * ( maxVal - minVal ) );
            return minVal + Math.floor( Math.random() * (  maxVal + 0.99999999 - minVal ) );
        }


        private function resetAndCreateEvos():void
        {
            var evoCount:Number = 1;
            var evo:IEvolver = firstEvo;

            do
            {
                if ( !evo.next && evoCount < numEvos )
                {
                    evo.next = new ShapeShifterEvolver( sourceImg.width, sourceImg.height );
                    evo.next.previous = evo;
                    evoList.push( evo.next );
                }

                if ( evoList.length > 1 && numPopulations > 1 )
                {
                    evo.genome = evoList[ 0 ].genome.mate( evoList[ 1 ].genome );
                }

                ShapeShifterEvolver( evo ).reset( minSize, maxSize );

                evoCount++;

                evo = evo.next;

            }
            while ( evo );

            layer = new Sprite();
            holder.addChild( layer );
        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        private function enterFrameHandler( e:Event ):void
        {
            evolve();
        }


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function evolve():void
        {
            var evo:IEvolver;
            var bm:Bitmap, bmWidth:uint, bmHeight:uint, sourceSegment:BitmapData;
            var difference:uint, numPixels:uint, numUsedPixels:uint, bmPix:uint, sourcePix:uint;
            var rDiff:Number, gDiff:Number, bDiff:Number;
            var sourceVector:Vector.<uint>, bmVector:Vector.<uint>;
            var fitness:Number;

            evo = firstEvo;
            var newPopulationFitness:Number = 0;
            var matrix:Matrix = new Matrix();

            do
            {
                if ( ShapeShifterEvolver( evo ).momentum != 0 )
                {
                    bm = evo.draw();
                    bmWidth = bm.width;
                    bmHeight = bm.height;

                    sourceSegment = new BitmapData( bmWidth, bmHeight, false );
                    matrix.tx = -bm.x;
                    matrix.ty = -bm.y;

                    sourceSegment.draw( sourceImg, matrix );

                    difference = 0;
                    numUsedPixels = 0;

                    sourceVector = sourceSegment.getVector( sourceSegment.rect );
                    bmVector = bm.bitmapData.getVector( bm.bitmapData.rect );

                    numPixels = sourceVector.length;

                    for ( var j:int = 0; j < numPixels; j++ )
                    {
                        bmPix = bmVector[ j ];

                        if ( ( bmPix >> 24 & 0xFF ) != 0x00 )
                        {
                            sourcePix = sourceVector[ j ];

                            rDiff = ( bmPix >> 16 & 0xFF ) - ( sourcePix >> 16 & 0xFF );
                            gDiff = ( bmPix >> 8 & 0xFF ) - ( sourcePix >> 8 & 0xFF );
                            bDiff = ( bmPix & 0xFF ) - ( sourcePix & 0xFF );

                            difference += ( rDiff >= 0 ) ? rDiff : -rDiff;
                            difference += ( gDiff >= 0 ) ? gDiff : -gDiff;
                            difference += ( bDiff >= 0 ) ? bDiff : -bDiff;

                            numUsedPixels++;
                        }
                    }

                    difference = difference / numUsedPixels;

                    //765 is the worst fitness, where every color channel difference is 255
                    fitness = 1 - ( difference / 765 );

                    if ( evo.fitness < fitness )
                    {
                        var s:ShapeShifterEvolver = evo as ShapeShifterEvolver;
                        if ( s.bestDraw && layer.contains( s.bestDraw ) )
                            layer.removeChild( s.bestDraw );

                        evo.reward( fitness );

                        if ( _displayEnabled )
                            layer.addChild( s.bestDraw );
                    }
                    else
                    {
                        evo.punish( fitness );
                    }
                }

                newPopulationFitness += evo.fitness;

                evo = evo.next;

            }
            while ( evo );

            newPopulationFitness = newPopulationFitness / numEvos;
            momentumCalc.addSample( newPopulationFitness );
            numGenerations++;
            trace( "[" + numPopulations + "/" + maxNumPopulations + ":" + numGenerations + "] Fitness:" + newPopulationFitness + ". Momentum:" + momentumCalc.momentum );

            if ( newPopulationFitness > targetPopulationFitness || ( momentumCalc.isReady && ( momentumCalc.momentum < minGenerationMomentum ) ) )
            {
                trace( "finished population: " + ( numPopulations ) );

                evoList.sortOn( "fitness", Array.DESCENDING | Array.NUMERIC );

                for each ( var evolver:ShapeShifterEvolver in evoList )
                {
                    if ( evolver.bestDraw )
                    {
                        layer.addChildAt( evolver.bestDraw, 0 );
                    }
                }

                var layerBmd:BitmapData = new BitmapData( sourceImg.width, sourceImg.height, true, 0x00000000 )
                layerBmd.draw( layer );

                holder.addChild( new Bitmap( layerBmd ) )
                holder.removeChild( layer );

                if ( numPopulations == maxNumPopulations )
                {
                    removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
                    trace( "Done. Total time: " + ( getTimer() - startTime ) );
                    return;
                }

                var relPop:Number = ( numPopulations / ( maxNumPopulations - 1 ) );
                numEvos = relPop * ( endEvos - startEvos ) + startEvos;
                minSize = ( 1 - relPop ) * ( startMinSize - endMinSize ) + endMinSize;
                maxSize = ( 1 - relPop ) * ( startMaxSize - endMaxSize ) + endMaxSize;

                resetAndCreateEvos();

                momentumCalc = new MomentumCalculator();

                numGenerations = 0;
                populationFitness = 0;
                numPopulations++;
            }
            else
            {
                populationFitness = newPopulationFitness;
            }
        }


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function btDisplayHandler( e:MouseEvent ):void
        {
            _displayEnabled = !_displayEnabled;
        }


    }
}