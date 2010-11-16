/*
* Modified version of Phil Burrows Prototype Facebox for use with
* the Redmine Knowledgebase Plugin (by Alex Bevilacqua)
* 
* based on Facebox by Chris Wanstrath -- http://famspam.com/facebox
* 
* :: ported to the Prototype JS library by ::
* Phil Burrows
* http://blog.philburrows.com
* peburrows@gmail.com
* Date: 3 May 2008
*
*
* Usage:
*  
* This Prototype version is setup to automatically run when the window's load event is fired (see last three lines of this file),
* so usage is as easy as adding rel="facebox" to any link you want to use Facebox
*
* AGAIN, kudos to to Chris Wanstrath and the guys from ErrFree for really putting in the brunt of the effort exerted on this
* I just spent an evening taking all their work and molding it into something that would use Prototype
*/


var Facebox = Class.create({
  initialize  : function(extra_set){
    this.settings = {
      // FIXME this path is hardcoded for the knowledgebase plugin. The logic should actually
      // be cleaned up if this functionality (facebox) is wanted in other plugins or 
      // redmine in general      
      close_image   : '/plugin_assets/redmine_knowledgebase/images/facebox/closelabel.gif',      
      inited        : true, 
      facebox_html  : '\
    <div id="facebox" style="display:none;"> \
      <div class="popup"> \
        <table> \
          <tbody> \
            <tr> \
              <td class="tl"/><td class="b"/><td class="tr"/> \
            </tr> \
            <tr> \
              <td class="b"/> \
              <td class="body"> \
                <div class="content"> \
                </div> \
                <div class="footer"> \
                  <a href="#" class="close"> \
                    <img src="/plugin_assets/redmine_knowledgebase/images/facebox/closelabel.gif" title="close" class="close_image" /> \
                  </a> \
                </div> \
              </td> \
              <td class="b"/> \
            </tr> \
            <tr> \
              <td class="bl"/><td class="b"/><td class="br"/> \
            </tr> \
          </tbody> \
        </table> \
      </div> \
    </div>'
    };
    if (extra_set) Object.extend(this.settings, extra_set);
    $$('body').first().insert({bottom: this.settings.facebox_html});
    
    this.preload = [ new Image() ];
    this.preload[0].src = this.settings.close_image;    
    
    f = this;
    $$('#facebox .b:first, #facebox .bl, #facebox .br, #facebox .tl, #facebox .tr').each(function(elem){
      f.preload.push(new Image());
      f.preload.slice(-1).src = elem.getStyle('background-image').replace(/url\((.+)\)/, '$1');
    });
    
    // this.keyPressListener = this.watchKeyPress().bindAsEventListener(this);
    
    this.watchClickEvents();
    fb = this;
    Event.observe($$('#facebox .close').first(), 'click', function(e){
      Event.stop(e);
      fb.close()
    });
    Event.observe($$('#facebox .close_image').first(), 'click', function(e){
      Event.stop(e);
      fb.close()
    });
  },
    
  watchClickEvents  : function(e){
    var f = this;
    $$('a[rel=facebox]').each(function(elem,i){
      Event.observe(elem, 'click', function(e){
        // console.log("here's what f is :: "+ f);
        Event.stop(e);
        f.click_handler(elem, e);
      });
    });
    
  },
  
  loading : function() {    
    contentWrapper = $$('#facebox .content').first();
    contentWrapper.childElements().each(function(elem, i){
      elem.remove();
    });    
   
    /* Center the box on the screen */
    var bdims = document.body.getDimensions();
    var fdims = $('facebox').getDimensions();
    var pageScroll = document.viewport.getScrollOffsets();
    
    $('facebox').setStyle({
      // top: ((bdims.height - fdims.height) / 2) + 'px', /* Center Height */
      top: pageScroll.top + (document.viewport.getHeight() / 10) + 'px', /* ViewPort Top */
      left: ((bdims.width - fdims.width)) / 2 + 'px',
      position: 'absolute'
    });
    
    Event.observe(document, 'keypress', this.keyPressListener);
  },
  
  reveal  : function(data, klass){
    this.loading();
    box = $('facebox');
    
    if(!box.visible()) box.show();
    
    contentWrapper = $$('#facebox .content').first();
    if (klass) contentWrapper.addClassName(klass);
    contentWrapper.insert({bottom: data});
    
    $$('#facebox .body').first().childElements().each(function(elem,i){
      elem.show();
    });
    Event.observe(document, 'keypress', this.keyPressListener);
  },
  
  close   : function(){
    $('facebox').hide();
  },
  
  click_handler : function(elem, e){
    this.loading();
    Event.stop(e);
    
    // support for rel="facebox[.inline_popup]" syntax, to add a class
    var klass = elem.rel.match(/facebox\[\.(\w+)\]/);
    if (klass) klass = klass[1];
    
    // div
    $('facebox').show();
    
    if (elem.href.match(/#/)){
      var url       = window.location.href.split('#')[0];
      var target    = elem.href.replace(url+'#','');
      // var data     = $$(target).first();
      var d     = $(target);
      // create a new element so as to not delete the original on close()
      var data = new Element(d.tagName);
      data.innerHTML = d.innerHTML;
      this.reveal(data, klass);
    } else {
      // Ajax
      var fb = this;
      url = elem.href;
      new Ajax.Request(url, {
        method    : 'get',
        onFailure : function(transport){
          fb.reveal(transport.responseText, klass);
        },
        onSuccess : function(transport){
          fb.reveal(transport.responseText, klass);
        }
      });
      
    }
  }
});

var facebox;
Event.observe(window, 'load', function(e){
  facebox = new Facebox();
});