<rhcvrfdetails>
    <hr>
    <div if={ isLoading } class='loader center-block'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:36px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >

        <h5 if={ rhdirectlink != null }>RH Direct Link: <a href="{ rhdirectlink }">{ rhdirectlink }</a></h5>
        <pre if={ prettyjson != null } id="json">{ prettyjson }</pre>  

        <div if={ prettyjson == null || prettyjson.length == 0 }>
            <div class="alert alert-info">No data retrieved.</div>
        </div>
    </div>

    <script>

        this.rhdirectlink = null;
        this.prettyjson = null;
        this.isLoading = false;
        this.error = null;

        var self = this

        doApiRequest(rhsa) {

            var apiurl = "/api/rhdb/cvrf/" + rhsa;

            self.rhdirectlink = null;
            self.prettyjson = null;
            self.isLoading = true;
            self.error = null;
            self.update();

            $.getJSON(apiurl, function(results) {
                //console.log(results.data);
                if (results.data !== null) {
                    self.rhdirectlink = results.data.rhlink;
                    self.prettyjson = JSON.stringify(results.data.jsondata, undefined, 2);
                }
            })
            .done(function() {
                // alert( "second success" );
            })
            .fail(function() {
                // alert( "error" );
                self.error = "Failed to retrieve data from server!";
            })
            .always(function() {
                // alert( "finished" );
                self.isLoading = false;
                self.update()
            });
        }

        self.on('mount', function(){

            self.doApiRequest(opts.rhsa);
        })

    </script>

</rhcvrfdetails>
