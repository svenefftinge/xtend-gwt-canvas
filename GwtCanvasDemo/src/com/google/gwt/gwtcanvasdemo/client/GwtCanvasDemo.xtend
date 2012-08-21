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

import com.google.gwt.canvas.client.Canvas
import com.google.gwt.canvas.dom.client.Context2d
import com.google.gwt.canvas.dom.client.CssColor
import com.google.gwt.core.client.EntryPoint
import com.google.gwt.user.client.Timer
import com.google.gwt.user.client.ui.Label
import com.google.gwt.user.client.ui.RootPanel

public class GwtCanvasDemo extends Timer implements EntryPoint {
  static val holderId = "canvasholder"

  static val upgradeMessage = "Your browser does not support the HTML5 Canvas. Please upgrade your browser to view this demo."

  Canvas canvas
  Canvas backBuffer
  LogoGroup logoGroup
  BallGroup ballGroup
  Lens lens
  
  // mouse positions relative to canvas
  int mouseX
  int mouseY

  //timer refresh rate, in milliseconds
  static val refreshRate = 25
  
  // canvas size, in px
  static val height = 400
  static val width = 600
  
  val redrawColor = CssColor::make("rgba(255,255,255,0.6)")
  Context2d context
  Context2d backBufferContext
  
  override void onModuleLoad() {
    canvas = Canvas::createIfSupported()
    backBuffer = Canvas::createIfSupported()
    if (canvas == null) {
      RootPanel::get(holderId).add(new Label(upgradeMessage))
      return
    }

    // init the canvases
    canvas.width = width + "px"
    canvas.height = height + "px"
    canvas.coordinateSpaceWidth = width
    canvas.coordinateSpaceHeight = height
    backBuffer.coordinateSpaceWidth = width
    backBuffer.coordinateSpaceHeight = height
    RootPanel::get(holderId).add(canvas)
    context = canvas.context2d
    backBufferContext = backBuffer.context2d
    
    // init the objects
    logoGroup = new LogoGroup(width, height, 18, 165)
    ballGroup = new BallGroup(width, height)
    lens = new Lens(35, 15, width, height, new Vector(320, 150), new Vector(1, 1))

    // init handlers
    initHandlers()
    
    // setup timer
    scheduleRepeating(refreshRate)
  }
  
  override run() {
    doUpdate
  }

  def void doUpdate() {
    // update the back canvas
    backBufferContext.fillStyle = redrawColor
    backBufferContext.fillRect(0, 0, width, height)
    logoGroup.update(mouseX, mouseY)
    ballGroup.update(mouseX, mouseY)
    logoGroup.draw(backBufferContext)
    ballGroup.draw(backBufferContext)

    // update the front canvas
    lens.update
    lens.draw(backBufferContext, context)
  }
  
  def void initHandlers() {
    canvas.addMouseMoveHandler [
        mouseX = getRelativeX(canvas.getElement())
        mouseY = getRelativeY(canvas.getElement())
    ]

    canvas.addMouseOutHandler [
        mouseX = -200
        mouseY = -200
    ]

    canvas.addTouchMoveHandler [
        preventDefault
        if (touches.length > 0) {
          val touch = touches.get(0)
          mouseX = touch.getRelativeX(canvas.element)
          mouseY = touch.getRelativeY(canvas.element)
        }
        preventDefault
    ]

    canvas.addTouchEndHandler [
        preventDefault
        mouseX = -200
        mouseY = -200
    ]

    canvas.addGestureStartHandler [
        preventDefault
    ]
  }
}