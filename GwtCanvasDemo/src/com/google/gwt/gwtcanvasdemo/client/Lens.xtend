/*
 * Licensed under the Apache License, Version 2.0 (the "License") you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

package com.google.gwt.gwtcanvasdemo.client

import com.google.gwt.canvas.dom.client.Context2d
import com.google.gwt.canvas.dom.client.CssColor
import com.google.gwt.canvas.dom.client.FillStrokeStyle
import com.google.gwt.core.client.GWT
import java.util.List
import org.eclipse.xtext.xbase.lib.Pair

public class Lens {
  val int radius
  val int mag
  val int width // maximum bounds of canvases
  val int height
  
  Vector pos
  Vector vel
  List<Pair<Integer,Integer>> lensArray = newArrayList
  
  // color of lens outline
  val FillStrokeStyle strokeStyle = CssColor::make("#333300")
  
  new(int radius, int mag, int w, int h, Vector initPos, Vector vel) {
    this.radius = radius
    this.mag = mag
    this.width = w
    this.height = h
    this.pos = initPos
    this.vel = vel
    
    // calculate lens array
    var int a
    var int b
    val s = Math::sqrt(radius*radius - mag*mag)
    for (y : -radius .. radius) {
      for (x : -radius .. radius) {
        if(x*x + y*y < s*s) {
          val z = Math::sqrt(radius*radius - x*x - y*y)
          a = (x * mag / z + 0.5) as int
          b = (y * mag / z + 0.5) as int
          val dstIdx = (y + radius) * 2 * radius + (x + radius)
          val srcIdx = (b + radius) * 2 * radius + (a + radius)
          lensArray += (dstIdx -> srcIdx)
        }
      }
    }
  }
  
  def void update() {
    if (pos.x + radius + vel.x > width || pos.x - radius + vel.x < 0) {
      vel.x = vel.x * -1
    }
    if (pos.y + radius + vel.y > height || pos.y - radius + vel.y < 0) {
      vel.y = vel.y *-1
    }
    
    pos.x = pos.x + vel.x
    pos.y = pos.y + vel.y
  }
  
  def void draw(Context2d back, Context2d front) {
    front.drawImage(back.getCanvas(), 0, 0)
    
    if (!GWT::isScript()) {
      // in devmode this effect is slow so we disable it here
    } else {
      val frontData = front.getImageData((pos.x - radius) as int, (pos.y - radius) as int, 2 * radius, 2 * radius)
      val frontPixels = frontData.getData()
      val backData = back.getImageData((pos.x - radius) as int, (pos.y - radius) as int, 2 * radius, 2 * radius)
      val backPixels = backData.data
      var int srcIdx
      var int dstIdx
      for(it : lensArray) {
        dstIdx = 4 * key
        srcIdx = 4 * value
        frontPixels.set(dstIdx + 0, backPixels.get(srcIdx + 0))
        frontPixels.set(dstIdx + 1, backPixels.get(srcIdx + 1))
        frontPixels.set(dstIdx + 2, backPixels.get(srcIdx + 2))
      }
      front.putImageData(frontData, (pos.x - radius) as int, (pos.y - radius) as int)
    }
    
    front.setStrokeStyle(strokeStyle)
    front.beginPath()
    front.arc(pos.x, pos.y, radius, 0, Math::PI * 2, true)
    front.closePath()
    front.stroke()
  }
}