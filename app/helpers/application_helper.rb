# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

    def box_blue_start
        box = "
<div class=\"depot-form\">
    <div class=\"border-left\">
        <div class=\"border-right\">
            <div class=\"border-top\">
                <div class=\"border-bottom\">
                    <div class=\"corner-top-left\">
                        <div class=\"corner-top-right\">
                            <div class=\"corner-bottom-left\">
                                <div class=\"corner-bottom-right\">
                                    <div class=\"width\">
                                        <div class=\"article-indent\">
                                            <div class=\"width\">"
    end

    def box_blue_end
        box = "
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>"
    end

    def box_grey_start
        box = "
<div class=\"border-left-main\">
    <div class=\"border-right-main\">                                                           
        <div class=\"border-top-main\">                                                         
            <div class=\"border-bottom-main\">                                                  
                <div class=\"corner-top-left-main\">                                            
                    <div class=\"corner-top-right-main\">                                       
                        <div class=\"corner-bottom-left-main\">                                 
                            <div class=\"corner-bottom-right-main\">                            
                                <div class=\"width\">                                      
                                    <div class=\"article-indent\">                         
                                        <div class=\"width\">"
    end

    def box_grey_end
        box = "
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>"
    end

    def format_date(date)
        date.strftime("%a %d/%m/%Y")
    end
end
