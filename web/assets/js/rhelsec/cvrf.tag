<cvrf>
    <h3>CVRF</h3>
    <p>Some content.</p>

    <div if={ isLoading } class='loader'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:24px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >
        <div if={ items.length }>
            <h4>CVRF Details</h4>
            <table class="table">
                <thead>
                    <tr>
                        <th>Type</th>
                    </tr>
                </thead>
                <tbody>
                    <tr each={ items }>
                        <td>{ this }</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div if={ items.length == 0 }>
            <div class="alert alert-info">No CVRF emitted.</div>
        </div>
    </div>


    <script type="text/javascript">

        this.items = [];
        this.isLoading = true;
        this.error = null;

        var self = this

        doApiRequest = function() {

            $.getJSON("/api/cvrf", function(results) {
                console.log(results);
                self.items = results.data;
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
            doApiRequest()
        })
    </script>

</cvrf>
