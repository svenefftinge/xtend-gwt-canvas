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
import com.google.gwt.dom.client.ImageElement
import com.google.gwt.user.client.ui.Image
import com.google.gwt.user.client.ui.RootPanel
import java.util.List

public class LogoGroup {
  val double width
  val double height
  val int numLogos
  val double radius
  Image logoImg
  List<Logo> logos
  boolean imageLoaded
  
  double k
  
  new(double width, double height, int numLogos, double radius) {
    this.width = width
    this.height = height
    this.numLogos = numLogos
    this.radius = radius

    // init logos array
    logos = newArrayList
    
    // init image
    logoImg = new Image("xtendlogo40_40.png")
    logoImg.addLoadHandler [
        imageLoaded = true
        // once image is loaded, init logo objects
        val ImageElement imageElement = logoImg.element.cast
        for (i : 1..numLogos) {
          logos += new Logo(imageElement) => [
	          pos.x = width / 2
	          pos.y = height / 2
          ]
        }
    ]
    logoImg.visible = false
    RootPanel::get.add(logoImg) // image must be on page to fire load
  }
  
  def void update(double mouseX, double mouseY) {
    if (!imageLoaded) {
      return
    }
    
    k = (k + Math::PI/2.0* 0.009)
    
    for (i : numLogos..1) {
      val logo = logos.get(i-1)
      val logoPerTPi = 2 * Math::PI * (i-1) / numLogos
      val goal = new Vector(width / 2 + radius * Math::cos(k + logoPerTPi), 
          height / 2 + radius * Math::sin(k + logoPerTPi))
      logo.goal.set(goal)
      logo.rot = k + logoPerTPi + Math::PI / 2.0
      
      val d = new Vector(mouseX, mouseY)
      d.sub(logo.pos)
      if (d.magSquared() < 50*50) {
        logo.goal = Vector::sub(logo.pos, d)
      }
      
      logo.update()
    }
  }
  
  def void draw(Context2d context) {
    if (!imageLoaded) {
      return
    }
    
    logos.forEach[ draw(context) ]
  }
}