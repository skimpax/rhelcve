<cvelist>
    <h3>Activities</h3>
    <p>Some content.</p>

    <div if={ isLoading } class='loader'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:24px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >
        <if cond={ results.length }>
            <then>
            <h4>Activity Types Details</h4>
            <table class="table">
                <thead>
                    <tr>
                        <th>Type</th>
                        <th>Status</th>
                        <th>Description</th>
                    </tr>
                </thead>
                <tbody>
                    <tr each={ items }>
                        <td>{ type }</td>
                        <td><i class={ enabled ? "fa fa-check-square" : "fa fa-square-o" } aria-hidden="true"></i></td>
                        <td>{ desc }</td>
                    </tr>
                </tbody>
            </table>
            </then>
        <else>
            <div class="alert alert-info">No activity type created yet. You can create one using dedicated button.</div>
        </else>
    </div>


    <script type="text/javascript">

        this.items = [];
        this.isLoading = true;
        this.error = null;

this.items = [
  { type: "1", typeimput: { cum: "10"}},
  { type: "2", typeimput: { cum: "20"}},
  { type: "3", typeimput: { cum: "30"}},
  ];
        var self = this

        doApiRequest = function() {

            $.getJSON("/api/activities", function(results) {
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

</cvelist>
